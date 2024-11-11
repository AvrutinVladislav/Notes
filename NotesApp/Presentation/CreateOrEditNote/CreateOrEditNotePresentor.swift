//
//  CreateOrEditNotePresentor.swift
//  NotesApp
//
//  Created by Vladislav on 17.10.2022.
//

import Foundation
import CoreData

class CreateOrEditNotePresentor {
    
    private var view: CreateOrEditNoteViewInput
    private let coreDataManager: CoreDataManager
    private let fbManager: FirebaseManager
    
    var state = CreateOrEditeNoteState.create
    var noteID: String?
    
    init(view: CreateOrEditNoteViewInput,
         coreDataManager: CoreDataManager,
         fbManager: FirebaseManager) {
        self.view = view
        self.coreDataManager = coreDataManager
        self.fbManager = fbManager
    }
    
}

//MARK: CreateOrEditNoteViewOutput
extension CreateOrEditNotePresentor: CreateOrEditNoteViewOutput {
    
    func viewDidLoad() {
        setupInitialState()
    }
    
    func saveNoteButtonDidTap(_ text: String) {
        view.showIndicator(true)
        switch state {
        case .create:
            view.setSaveButton(false)
            switch coreDataManager.createNote(note: text) {
            case .success(let result):
                view.updateID(result.id)
                switch fbManager.addNote(entity: NotesCellData(id: result.id, noteText: result.noteText, date: result.date), id: result.id) {
                case .success():
                    view.showIndicator(false)
                    view.onFinished()
                    view.setSaveButton(true)
                    view.popNotesViewController()
                case .failure:
                    view.showIndicator(false)
                    view.setSaveButton(true)
                    view.showAlert("Error", "Error to save note in Firebase")
                }
            case .failure:
                view.showIndicator(false)
                view.setSaveButton(true)
                view.showAlert("Error", "Error to save note in Coredata")
            }
            
        case .edit:
            if let id = noteID {
                switch coreDataManager.updateNote(id: id, note: text, date: Date()) {
                case .success():
                    switch fbManager.updateNote(entity: NotesCellData(id: id, noteText: text, date: Date()), id: id) {
                    case .success():
                        view.onFinished()
                        view.showIndicator(false)
                        view.setSaveButton(true)
                        view.popNotesViewController()
                    case .failure:
                        view.showIndicator(false)
                        view.setSaveButton(true)
                        view.showAlert("Error", "Error update note in  Firebase")
                    }
                case .failure:
                    view.showIndicator(false)
                    view.setSaveButton(true)
                    view.showAlert("Error", "Error update note in Coredata")
                }
            }
        }
    }
}

extension CreateOrEditNotePresentor {
    enum CreateOrEditeNoteState {
        case create
        case edit
    }
}

//MARK: Private CreateOrEditNoteViewOutput
private extension CreateOrEditNotePresentor {
    
    func setupInitialState() {
        if state == .edit {
            if let noteID = noteID {
                let result = coreDataManager.fetchData(predicate: NSPredicate(format: "id = %@", noteID))
                switch result {
                case .success(let note):
                    view.setNoteTextView(note.noteText)
                case .failure(_):
                    view.showAlert("Error", "Error edit note")
                    break
                }
            }
        }
    }
    
}
