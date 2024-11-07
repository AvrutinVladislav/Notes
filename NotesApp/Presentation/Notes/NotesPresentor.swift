//
//  NotesPresentor.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import Foundation

class NotesPresentor {
    
    weak var view: NotesViewInput?
    
    private var sections: [NotesSectionsData] = []
    private var deleteNotes: [NotesCellData] = []
}

//MARK: NotesViewOutput
extension NotesPresentor: NotesViewOutput {
    func viewDidLoad() {
        setupInitialState()
    }
    
    func deleteNote(_ model: NotesCellData) {
        view?.showIndicator(true)
        switch CoredataManager().deleteNote(predicate: NSPredicate.init(format: "id = %@", model.id)) {
            
        case .success:
            switch FirebaseManager().deleteNote(id: model.id) {
                
            case .success:
                if let sectionIndex = sections.firstIndex(where: { $0.sectionType == model.sectionType }),
                   let cellIndex = sections[sectionIndex].cells.firstIndex(where: { $0.id == model.id }) {
                    
                    sections[sectionIndex].cells.remove(at: cellIndex)
                    view?.reloadTableView(sections: sections)
                    view?.showIndicator(false)
                }
            case .failure:
                deleteNotes.append(model)
                view?.showIndicator(false)
                view?.showAlert("Error", Errors.deleteFirebase.errorDescription)
            }
        case .failure:
            view?.showIndicator(false)
            view?.showAlert("Error", Errors.deleteCoredata.errorDescription)
        }        
    }
    
    func didSelectCell(_ model: NotesCellData) {
        
        if let sectionType = model.sectionType {
            view?.pushCreateOrEditeViewController(noteID: model.id, sectionType: sectionType)
        }
    }
    
    func addNoteButtonDidTap() {
        view?.pushCreateOrEditeViewController(noteID: nil, sectionType: .today)
    }
    
    func singOutButtonDidTap() {
        switch FirebaseManager().signOut() {
        case .success():
            CoredataManager().deleteAllNotes("NotesList")
            view?.popViewController()
        case .failure:
            view?.showAlert("Error", Errors.signOut.errorDescription)
        }
    }
    
    func didAddCell(_ id: String, _ sectionType: NotesSectionsData.SectionsType) {
        let result = CoredataManager().fetchData(predicate: NSPredicate(format: "id = %@", id))
        switch result {
        case .success(let note):
            let cell = NotesCellData(id: note.id,
                                     noteText: note.noteText,
                                     date: note.date,
                                     sectionType: .today)
            if let sectionIndex = sections.firstIndex(where: { $0.sectionType == sectionType }) {
                if let index = sections[sectionIndex].cells.firstIndex(where: { $0.id == cell.id }) {
                    sections[sectionIndex].cells.remove(at: index)
                }
            }
            if let sectionIndex = sections.firstIndex(where: { $0.sectionType == .today }) {
                sections[sectionIndex].cells.insert(cell, at: 0)
                view?.reloadTableView(sections: sections)
            } else {
                sortData()
            }
            
        case .failure:
            view?.showAlert("Error", Errors.fetchCoredata.errorDescription)
            break
        }
    }
    
    func refreshTableView() {
        switch CoredataManager().fetchData() {
        case .success(let cdFetchResult):
            let data = cdFetchResult.map { buildCell(noteText: $0.noteText, date: $0.date, id: $0.id) }
            switch FirebaseManager().updateNote(entities: data) {
            case .success:
                FirebaseManager().fetchDataFromFB { result in
                    switch result {
                    case .success(let fbFetchResult):
                        fbFetchResult.forEach { remoteNote in
                            if !data.contains(where: {$0.id == remoteNote.id}) {
                                self.updateCoreData(remoteNote: remoteNote)
                            }
                        }
                        self.sortData()
                    case .failure:
                        print("error fetch from fb")
                    }
                }
            case .failure:
                print("error update fb from coredata")
            }
        case .failure:
            print(" error fetch from coredata")
        }
        view?.endRefresh()
    }
   
}

//MARK: - Private
private extension NotesPresentor {
    func setupInitialState() {
        deleteNotesFromFBIfNeeded()
        checkChanges()
    }
    
    func buildCell(noteText: String, date: Date, id: String) -> NotesCellData {
        return NotesCellData(id: id, noteText: noteText, date: date)
    }
    
    func sortData() {
        switch CoredataManager().fetchData() {
        case .success(let result):
            let cells = result.sorted(by: { $0.date > $1.date }).map { buildCell(noteText: $0.noteText, date: $0.date, id: $0.id) }
            sections = buildSections(cells: cells)
            view?.reloadTableView(sections: sections)
        case .failure:
            print("Error fetch from firebase when sortData()")
            break
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
    }
    
    func checkChanges() {
        self.view?.showIndicator(true)
        switch CoredataManager().fetchData() {
        case .success(let cdFetchResult):
            let data = cdFetchResult.map { buildCell(noteText: $0.noteText, date: $0.date, id: $0.id) }
            switch FirebaseManager().updateNote(entities: data) {
            case .success:
                FirebaseManager().fetchDataFromFB { result in
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
                        self.view?.showIndicator(false)
                    case .failure:
                        self.view?.showIndicator(false)
                        print("error fetch from fb")
                    }
                }
            case .failure:
                self.view?.showIndicator(false)
                print("error update fb from coredata")
            }
        case .failure:
            self.view?.showIndicator(false)
            print(" error fetch from coredata")
        }
    }
    
    func updateCoreData(remoteNote: NotesCellData) {
        switch CoredataManager().updateNote(id: remoteNote.id, note: remoteNote.noteText, date: remoteNote.date) {
        case .success():
            break
        case .failure:
            view?.showAlert("Error", Errors.updateCoredata.errorDescription)
        }
    }
    
    func addToFireBase(localNote: NotesCellData) {
        switch FirebaseManager().addNote(entity: localNote, id: localNote.id) {
        case .success():
            break
        case .failure:
            view?.showAlert("Error", Errors.addFirebase.errorDescription)
        }
    }
    
    func addToCoreDateFromFB(remoteNote: NotesCellData) {
        switch CoredataManager().addNoteFromFB(id: remoteNote.id, note: remoteNote.noteText, date: remoteNote.date) {
        case .success:
            break
        case .failure:
            view?.showAlert("Error", Errors.addCoredataFromFB.errorDescription)
        }
    }
    
    func deleteNotesFromFBIfNeeded() {
        //будет проведено удаление данных, которые не удалились из firebase при удалении их из coredata
        deleteNotes.forEach { note in
            switch FirebaseManager().deleteNote(id: note.id) {
            case .success:
                break
            case .failure:
                view?.showAlert("Error", Errors.deleteFB.errorDescription)
            }
        }
    }
}
  
//MARK: Errors
extension NotesPresentor {
    enum Errors: LocalizedError {
        case updateFirebase
        case updateCoredata
        case addFirebase
        case addCoredataFromFB
        case signOut
        case fetchCoredata
        case fetchFirebase
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
