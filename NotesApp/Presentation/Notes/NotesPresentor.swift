//
//  NotesPresentor.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import Foundation

class NotesPresentor {
    
    private let view: NotesViewInput
    private let coreDataManager: CoreDataManager
    private let fbManager: FirebaseManager
    
    private var sections: [NotesSectionsData] = []
    private var deleteNotes: [NotesCellData] = []
    
    private var notesIsHidden = true
    
    init(view: NotesViewInput,
         coreDataManager: CoreDataManager,
         fbManager: FirebaseManager) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.fbManager = fbManager
    }
}

//MARK: NotesViewOutput
extension NotesPresentor: NotesViewOutput {
    func viewDidLoad() {
        setupInitialState()
    }
    
    func deleteNote(_ note: NotesCellData) {
        view.showIndicator(true)
        switch coreDataManager.deleteNote(predicate: NSPredicate.init(format: "id = %@", note.id)) {
        case .success:
            switch fbManager.deleteNote(id: note.id) {
            case .success:
                if let sectionIndex = sections.firstIndex(where: { $0.sectionType == note.sectionType }),
                   let cellIndex = sections[sectionIndex].cells.firstIndex(where: { $0.id == note.id }) {
                    sections[sectionIndex].cells.remove(at: cellIndex)
                    view.reloadTableView(sections: sections)
                    view.showIndicator(false)
                }
            case .failure:
                deleteNotes.append(note)
                view.showIndicator(false)
                view.showAlert("Error", Errors.deleteFirebase.errorDescription)
            }
        case .failure:
            view.showIndicator(false)
            view.showAlert("Error", Errors.deleteCoredata.errorDescription)
        }
    }
    
    func didSelectCell(_ note: NotesCellData) {
        if let sectionType = note.sectionType {
            view.pushCreateOrEditeViewController(noteID: note.id,
                                                 sectionType: sectionType,
                                                 state: .edit)
        }
    }
    
    func addNoteButtonDidTap() {
        view.pushCreateOrEditeViewController(noteID: nil,
                                             sectionType: .today,
                                             state: .create)
    }
    
    func singOutButtonDidTap() {
        switch FirebaseManagerImpl().signOut() {
        case .success():
            CoreDataManagerImpl().deleteAllNotes("NotesList")
            view.popToSignIn()
        case .failure:
            view.showAlert("Error", Errors.signOut.errorDescription)
        }
    }
    
    func didAddCell(_ id: String,
                    _ sectionType: NotesSectionsData.SectionsType) {
        let result = CoreDataManagerImpl().fetchData(predicate: NSPredicate(format: "id = %@", id))
        switch result {
        case .success(let note):
            let cell = NotesCellData(id: note.id,
                                     noteText: note.noteText,
                                     date: note.date,
                                     sectionType: .today,
                                     isDone: note.isDone)
            if let sectionIndex = sections.firstIndex(where: { $0.sectionType == sectionType }) {
                if let index = sections[sectionIndex].cells.firstIndex(where: { $0.id == cell.id }) {
                    sections[sectionIndex].cells.remove(at: index)
                }
            }
            if let sectionIndex = sections.firstIndex(where: { $0.sectionType == .today }) {
                sections[sectionIndex].cells.insert(cell, at: 0)
                view.reloadTableView(sections: sections)
            } else {
                sortData()
            }
            
        case .failure:
            view.showAlert("Error", Errors.fetchCoredata.errorDescription)
            break
        }
    }
    
    func refreshTableView() {
        switch coreDataManager.fetchData() {
        case .success(let cdFetchResult):
            let data = cdFetchResult.map { buildCell(noteText: $0.noteText,
                                                     date: $0.date,
                                                     id: $0.id,
                                                     isDone: $0.isDone) }
            switch fbManager.updateNotes(entities: data) {
            case .success:
                fbManager.fetchDataFromFB { result in
                    switch result {
                    case .success(let fbFetchResult):
                        fbFetchResult.forEach { remoteNote in
                            if !data.contains(where: {$0.id == remoteNote.id}) {
                                self.updateCoreData(remoteNote: remoteNote)
                            }
                        }
                        self.sortData()
                    case .failure:
                        print(Errors.fetchFirebase.errorDescription)
                    }
                }
            case .failure:
                print(Errors.updateCoredata.errorDescription)
            }
        case .failure:
            print(Errors.fetchCoredata.errorDescription)
        }
        view.endRefresh()
    }
    
    func doneButtonTapped(_ id: String) {
        let result = coreDataManager.fetchData(predicate: NSPredicate(format: "id = %@", id))
        switch result {
        case .success(let note):
            switch coreDataManager.updateNote(id: note.id,
                                              note: note.noteText,
                                              date: note.date,
                                              isDone: !note.isDone) {
            case .success():
                switch fbManager.updateNote(entity: NotesCellData(id: id,
                                                                  noteText: note.noteText,
                                                                  date: note.date,
                                                                  isDone: !note.isDone),
                                            id: id) {
                case .success():
                    updateCell(id)
                    sortDoneNotes()
                case .failure:
                    print("Error", Errors.updateFirebase.errorDescription)
                }
            case .failure:
                print("Error", Errors.updateCoredata.errorDescription)
            }
        case .failure(_):
            print("Error", Errors.fetchCoredata.errorDescription)
        }
        view.reloadTableView(sections: sections)
    }
    
    func doneNotesIsHidden(_ isHiddenNotes: Bool) {
        switch coreDataManager.fetchData() {
        case .success(let notes):
            if isHiddenNotes {
                let data = notes.filter { $0.isDone == false}.map { note in
                    buildCell(noteText: note.noteText, date: note.date, id: note.id, isDone: note.isDone)
                }
                sections = sortSections(buildSections(cells: data))
            } else {
                sections = sortSections(buildSections(cells: notes.map({ note in
                    buildCell(noteText: note.noteText, date: note.date, id: note.id, isDone: note.isDone)
                })))
            }
            notesIsHidden.toggle()
            sortDoneNotes()
            view.reloadTableView(sections: sections)
        case .failure(_):
            print(Errors.fetchCoredata.errorDescription)
        }
    }
    
    func settingsButtonDidTap() {
        
    }
    
}

//MARK: - Private
private extension NotesPresentor {
    func setupInitialState() {
        deleteNotesFromFBIfNeeded()
        checkChanges()
    }
    
    func buildCell(noteText: String,
                   date: Date,
                   id: String,
                   isDone: Bool) -> NotesCellData {
        return NotesCellData(id: id,
                             noteText: noteText,
                             date: date,
                             isDone: isDone)
    }
    
    func sortData() {
        switch coreDataManager.fetchData() {
        case .success(let result):
            let cells = result.sorted(by: { $0.date > $1.date }).map { buildCell(noteText: $0.noteText,
                                                                                 date: $0.date,
                                                                                 id: $0.id,
                                                                                 isDone: $0.isDone) }
            sections = buildSections(cells: cells)
            sortDoneNotes()
            doneNotesIsHidden(notesIsHidden)
            view.reloadTableView(sections: sections)
        case .failure:
            print(Errors.fetchFbWhenSortData.errorDescription)
            break
        }
    }
    
    func updateCell(_ id: String) {
        sections = sections.map { section in
            var updatedSection = section
            if let cell = updatedSection.cells.first(where: {$0.id == id}) {
                updatedSection.cells.removeAll(where: {$0.id == id})
                updatedSection.cells.append(NotesCellData(id: id,
                                                          noteText: cell.noteText,
                                                          date: cell.date,
                                                          isDone: !cell.isDone))
            }
            return updatedSection
        }
    }

    func sortDoneNotes() {
        for i in sections.indices {
            sections[i].cells.sort {
                if $0.isDone != $1.isDone {
                    return $0.isDone
                }
                return $0.date < $1.date
            }
        }
    }
    
    func buildSections(cells: [NotesCellData]) -> [NotesSectionsData] {
        var buildSections: [NotesSectionsData] = []
        func sortDataForSections(by key: NotesSectionsData.SectionsType, item: NotesCellData) {
            if let index = buildSections.firstIndex(where: { $0.sectionType == key }) {
                buildSections[index].cells.append(item)
            } else {
                let section = NotesSectionsData(sectionType: key, cells: [item])
                buildSections.append(section)
            }
        }
        for var cell in cells {
            if cell.date.isToday {
                cell.sectionType = .today
                sortDataForSections(by: .today, item: cell)
            } else if cell.date.isYesterday {
                cell.sectionType = .yesterday
                sortDataForSections(by: .yesterday, item: cell)
            } else if cell.date.isWeek {
                cell.sectionType = .week
                sortDataForSections(by: .week, item: cell)
            } else if cell.date.isMounth {
                cell.sectionType = .mounth
                sortDataForSections(by: .mounth, item: cell)
            } else if cell.date.isYear {
                cell.sectionType = .year
                sortDataForSections(by: .year, item: cell)
            }
        }
        return buildSections
    }
    
    func checkChanges() {
        self.view.showIndicator(true)
        switch coreDataManager.fetchData() {
        case .success(let cdFetchResult):
            let data = cdFetchResult.map { buildCell(noteText: $0.noteText,
                                                     date: $0.date,
                                                     id: $0.id,
                                                     isDone: $0.isDone) }
            switch fbManager.updateNotes(entities: data) {
            case .success:
                fbManager.fetchDataFromFB { result in
                    switch result {
                    case .success(let fbFetchResult):
                        fbFetchResult.forEach { remoteNote in
                            if data.contains(where: {$0.id == remoteNote.id}) {
                                self.updateCoreData(remoteNote: remoteNote)
                            } else {
                                self.addToCoreDateFromFB(remoteNote: remoteNote)
                            }
                        }
                        self.sortData()
                        self.sections = self.sortSections(self.sections)
                        self.doneNotesIsHidden(true)
                        self.view.showIndicator(false)
                    case .failure:
                        self.view.showIndicator(false)
                        print(Errors.fetchFirebase.errorDescription)
                    }
                }
            case .failure:
                self.view.showIndicator(false)
                print(Errors.updateFbFromCoredata.errorDescription)
            }
        case .failure:
            self.view.showIndicator(false)
            print(Errors.fetchCoredata.errorDescription)
        }
    }
    
    func updateCoreData(remoteNote: NotesCellData) {
        switch coreDataManager.updateNote(id: remoteNote.id,
                                          note: remoteNote.noteText,
                                          date: remoteNote.date,
                                          isDone: remoteNote.isDone) {
        case .success():
            break
        case .failure:
            view.showAlert("Error", Errors.updateCoredata.errorDescription)
        }
    }
    
    func addToFireBase(localNote: NotesCellData) {
        switch fbManager.addNote(entity: localNote,
                                 id: localNote.id) {
        case .success():
            break
        case .failure:
            view.showAlert("Error", Errors.addFirebase.errorDescription)
        }
    }
    
    func addToCoreDateFromFB(remoteNote: NotesCellData) {
        switch coreDataManager.addNoteFromFB(id: remoteNote.id,
                                             note: remoteNote.noteText,
                                             date: remoteNote.date,
                                             isDone: remoteNote.isDone) {
        case .success:
            break
        case .failure:
            view.showAlert("Error", Errors.addCoredataFromFB.errorDescription)
        }
    }
    
    func deleteNotesFromFBIfNeeded() {
        //будет проведено удаление данных, которые не удалились из firebase при удалении их из coredata
        deleteNotes.forEach { note in
            switch FirebaseManagerImpl().deleteNote(id: note.id) {
            case .success:
                break
            case .failure:
                view.showAlert("Error", Errors.deleteFB.errorDescription)
            }
        }
    }
    
    func sortSections(_ sections: [NotesSectionsData]) -> [NotesSectionsData] {
        let orderedSections: [NotesSectionsData.SectionsType] = [
            .today,
            .yesterday,
            .week,
            .mounth,
            .year
        ]
        return sections.sorted {
                guard
                    let firstIndex = orderedSections.firstIndex(of: $0.sectionType),
                    let secondIndex = orderedSections.firstIndex(of: $1.sectionType)
                else {
                    return false
                }
                return firstIndex < secondIndex
            }
    }
}
  
//MARK: Errors
extension NotesPresentor {
    enum Errors: LocalizedError {
        case updateFirebase
        case updateCoredata
        case updateFbFromCoredata
        case addFirebase
        case addCoredataFromFB
        case signOut
        case fetchCoredata
        case fetchFirebase
        case fetchFbWhenSortData
        case laterButtonEnter
        case deleteCoredata
        case deleteFirebase
        case deleteFB
        
        var errorDescription: String {
            switch self {
            case .updateFirebase:
                return "Error to update Firebase".localized()
            case .updateCoredata:
                return "Error to update Coredata".localized()
            case .updateFbFromCoredata:
                return "Error update Firebase from Coredata".localized()
            case .addFirebase:
                return "Error to add note in Firebase".localized()
            case .addCoredataFromFB:
                return "Error to add note in Coredata from Firebase".localized()
            case .signOut:
                return "Error sign out".localized()
            case .fetchCoredata:
                return "Error fetch data from Coredata".localized()
            case .fetchFirebase:
                return "Error fetch data from Firebase".localized()
            case .fetchFbWhenSortData:
                return "Error fetch data from Firebase when sort data".localized()
            case .laterButtonEnter:
                return "Logged in without authorization, cloud saving is not available".localized()
            case .deleteCoredata:
                return "Failed to delete note from storage".localized()
            case .deleteFirebase:
                return "Failed to delete note from cloud storage".localized()
            case .deleteFB:
                return "Failed to delete note from cloud storage, the next uninstallation attempt will be made after the application is restarted".localized()
            }
        }
    }
    
}
