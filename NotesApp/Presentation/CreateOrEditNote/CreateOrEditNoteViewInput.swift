//
//  CreateOrEditeNoteViewInput.swift
//  NotesApp
//
//  Created by Vladislav on 17.10.2022.
//

import Foundation

protocol CreateOrEditNoteViewInput: AnyObject {
    
    func popNotesViewController()
    func setNoteTextView(_ text: String)
    func onFinished()
    func showAlert(_ title: String, _ message: String) 
    func updateID(_ id: String)
    func showIndicator(_ isActive: Bool)
    func setSaveButton(_ isActive: Bool)
}
