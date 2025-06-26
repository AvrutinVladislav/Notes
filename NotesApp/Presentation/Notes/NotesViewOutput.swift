//
//  NotesViewOutput.swift
//  NotesApp
//
//  Created by Vladislav on 10.10.2022.
//

import Foundation

protocol NotesViewOutput: AnyObject {
    
    func viewDidLoad()
    func didSelectCell(_ model: NotesCellData)
    func deleteNote(_ model: NotesCellData)
    func singOutButtonDidTap()
    func addNoteButtonDidTap()
    func didAddCell(_ id: String, _ sectionType: NotesSectionsData.SectionsType)
    func refreshTableView()
    func doneButtonTapped(_ id: String)
    func doneNotesIsHidden(_ isHiddenNotes: Bool)
    func settingsButtonDidTap()
}
