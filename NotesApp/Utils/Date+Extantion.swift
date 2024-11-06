//
//  Date+Extantion.swift
//  NotesApp
//
//  Created by Vladislav on 18.10.2022.
//

import Foundation

extension Date {
    
    func isFormate(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        
    }
    
    func dateOnly() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
    }
    
    var isToday: Bool {
        
        return Calendar.current.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        
        return Calendar.current.isDateInYesterday(self)
    }
    
    var isWeek: Bool {
        
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isMounth: Bool {
        
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    var isYear: Bool {
        
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }
    
    enum DateIntervalState {
        
        case today(date: Date)
        case yesterday(date: Date)
        case week(date: Date)
        case mounth(date: Date)
        case year(date: Date)
        
        var isRightState: Bool {
            
            switch self {
            case .today(let date):
                return Calendar.current.isDateInToday(date)
            case .yesterday(let date):
                return Calendar.current.isDateInYesterday(date)
            case .week(let date):
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
            case .mounth(let date):
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
            case .year(let date):
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
            }
        }
    }
    
}
