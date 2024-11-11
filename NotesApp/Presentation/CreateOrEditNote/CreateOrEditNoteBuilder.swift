//
//  CreateOrEditNoteBuilder.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 09.11.2024.
//

import Foundation

final class CreateOrEditNoteBuilder {
    class func build(id: String?,
                     sectionType: NotesSectionsData.SectionsType,
                     state: CreateOrEditeNoteState) -> CreateOrEditNoteViewController {
        let view = CreateOrEditNoteViewController()
        view.noteID = id
        view.sectionType = sectionType
        view.state = state
        let fbManager: FirebaseManager = AppContainer.shared.inject()
        let coreDataManager: CoreDataManager = AppContainer.shared.inject()
        let presenter = CreateOrEditNotePresentor(view: view,
                                                  coreDataManager: coreDataManager,
                                                  fbManager: fbManager,
                                                  state: state,
                                                  noteID: id)
        view.output = presenter
        return view
    }
}
