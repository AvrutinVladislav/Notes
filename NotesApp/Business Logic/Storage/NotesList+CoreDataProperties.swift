//
//  NoteList+CoreDataProperties.swift
//  
//
//  Created by Vladislav on 17.10.2022.
//
//

import Foundation
import CoreData

@objc(NotesList)
public class NotesList: NSManagedObject {

}

extension NotesList {
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<NotesList> {
        return NSFetchRequest<NotesList>(entityName: "NotesList")
    }
    @NSManaged public var noteText: String
    @NSManaged public var date: Date
    @NSManaged public var id: String
    @NSManaged public var isDone: Bool    
}
