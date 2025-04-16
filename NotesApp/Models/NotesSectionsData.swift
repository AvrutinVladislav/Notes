//
//  NotesSectionsData.swift
//  NotesApp
//
//  Created by Vladislav on 13.10.2022.
//

import Foundation

struct NotesSectionsData {
    
    let sectionType: SectionsType
    var cells = [NotesCellData]()
    
    enum SectionsType: String {
        case yesterday
        case today
        case week
        case mounth
        case year
        
        var localaizeHeader: String {
            switch self {
            case .today:
                return "Today".localized()
            case .yesterday:
                return "Yesterday".localized()
            case .week:
                return "Week".localized()
            case .mounth:
                return "Mounth".localized()
            case .year:
                return "Year".localized()
            }
        }
    }
    
}

