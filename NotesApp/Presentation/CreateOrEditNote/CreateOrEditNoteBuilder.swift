//
//  CreateOrEditNoteBuilder.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 09.11.2024.
//

import Foundation

final class CreateOrEditNoteBuilder {
    class func build() -> CreateOrEditNoteViewController {
        let view = CreateOrEditNoteViewController()
        let fbManager = FirebaseManagerImpl()
        let coreDataManager = CoreDataManagerImpl()
        let presenter = CreateOrEditNotePresentor(view: view,
                                                  coreDataManager: coreDataManager,
                                                  fbManager: fbManager)
        view.output = presenter
        return view
    }
}
