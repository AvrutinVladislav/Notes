//
//  NotesViewInput.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import Foundation

protocol NotesViewInput: AnyObject {
    
    func reloadTableView(sections: [NotesSectionsData])
    func pushCreateOrEditeViewController(noteID: String?,
                                         sectionType: NotesSectionsData.SectionsType,
                                         state: CreateOrEditeNoteState)
    func popViewController()
    func showAlert(_ title: String,
                   _ message: String)
    func showIndicator(_ isActive: Bool)
    func endRefresh()
}
