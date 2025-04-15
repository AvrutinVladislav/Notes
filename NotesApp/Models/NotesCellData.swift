//
//  NotesCellData.swift
//  NotesApp
//
//  Created by Vladislav on 13.10.2022.
//

import Foundation

enum CreateOrEditeNoteState {
    case create
    case edit
}

struct NotesCellData {
    
    var id: String
    var noteText: String
    var date: Date
    var sectionType: NotesSectionsData.SectionsType?
    var isDone: Bool
}

extension NotesCellData: Equatable {
        
    static func == (lhs: NotesCellData, rhs: NotesCellData) -> Bool {
        return lhs.id == rhs.id &&
               lhs.noteText == rhs.noteText &&
               lhs.date == rhs.date &&
               lhs.isDone  == rhs.isDone
    }
}

extension NotesCellData: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case title
        case date
        case id
        case sectionType
        case isDone
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(noteText, forKey: .title)
        try container.encode(date, forKey: .date)
        try container.encode(id, forKey: .id)
        try container.encode(sectionType?.rawValue, forKey: .sectionType)
        try container.encode(isDone, forKey: .isDone)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        noteText = try container.decode(String.self, forKey: .title)
        date = try container.decode(Date.self, forKey: .date)
        id = try container.decode(String.self, forKey: .id)
        if let sectionTypeString = try container.decodeIfPresent(String.self, forKey: .sectionType) {
            sectionType = NotesSectionsData.SectionsType(rawValue: sectionTypeString)
        }
        isDone = try container.decode(Bool.self, forKey: .isDone)
    }
    
}

