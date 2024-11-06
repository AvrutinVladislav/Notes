//
//  CreateOrEditNoteViewOutput.swift
//  NotesApp
//
//  Created by Vladislav on 17.10.2022.
//

import Foundation

protocol CreateOrEditNoteViewOutput: AnyObject {
    
    func viewDidLoad()
    func saveNoteButtonDidTap(_ text: String)
}
