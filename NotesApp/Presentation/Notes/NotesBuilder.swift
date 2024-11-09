//
//  NotesBuilder.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 09.11.2024.
//

import Foundation

final class NotesBuilder {
    class func build() -> NotesViewController {
        let view = NotesViewController()
        let fbManager = FirebaseManagerImpl()
        let coreDataManager = CoreDataManagerImpl()
        let presenter = NotesPresentor(view: view,
                                       coreDataManager: coreDataManager,
                                       fbManager: fbManager)
        view.output = presenter
        return view
    }
}
