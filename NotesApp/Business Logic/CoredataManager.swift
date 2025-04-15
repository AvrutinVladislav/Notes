//
//  CorebaseManager.swift
//  NotesApp
//
//  Created by Vladislav on 21.10.2022.
//

import Foundation
import CoreData

protocol CoreDataManager {
    func fetchData() -> Result<[NotesList], Error>
    func fetchData(predicate: NSPredicate) -> Result<NotesList, Error>
    func createNote(note: String) -> Result<NotesList, Error>
    func deleteNote(predicate: NSPredicate) -> Result<Void, Error>
    func deleteAllNotes(_ entity: String)
    func addNoteFromFB(id: String, note: String, date: Date, isDone: Bool) -> Result<Void, Error>
    func updateNote(id: String, note: String, date: Date, isDone: Bool) -> Result<Void, Error>
}

final class CoreDataManagerImpl: CoreDataManager {
    
    init(){}
    
    func fetchData() -> Result<[NotesList], Error> {
        let context = persistentContainer.viewContext
        do {
            let items = try context.fetch(NotesList.createFetchRequest())
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchData(predicate: NSPredicate) -> Result<NotesList, Error> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NotesList> = NotesList.createFetchRequest()
        fetchRequest.predicate = predicate
        do {
            var note = NotesList()
            if let item = try context.fetch(fetchRequest).first {
                note = item }
            return .success(note)
        } catch {
            return .failure(error)
        }
    }
    
    func createNote(note: String) -> Result<NotesList, Error>  {
        let context = persistentContainer.viewContext
        let newNote = NotesList(context: context)
        newNote.noteText = note
        newNote.date = Date()
        newNote.id = UUID().uuidString
        saveContext()
        do {
            try context.save()
            return .success(newNote)
        } catch {
            return .failure(error)
        }
    }
    
    func deleteNote(predicate: NSPredicate) -> Result<Void, Error> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NotesList> = NotesList.createFetchRequest()
        fetchRequest.predicate = predicate
        do {
            if let result = try context.fetch(fetchRequest).first {
                context.delete(result)
                try context.save()
                saveContext()
            }
        } catch {
            return .failure(error)
        }
        saveContext()
        return .success(())
    }

    func deleteAllNotes(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest)
            for object in result {
                guard let objectData = object as? NSManagedObject else { continue }
                persistentContainer.viewContext.delete(objectData)
                saveContext()
            }
        } catch let error {
            print("Delete all data in \(entity) error : ", error)
        }
    }
    
    func addNoteFromFB(id: String, note: String, date: Date, isDone: Bool) -> Result<Void, Error> {
        let context = persistentContainer.viewContext
        let newNote = NotesList(context: context)
        newNote.noteText = note
        newNote.date = date
        newNote.id = id
        newNote.isDone = isDone
        saveContext()
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func updateNote(id: String, note: String, date: Date, isDone: Bool) -> Result<Void, Error> {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NotesList> = NotesList.createFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        saveContext()
        do {
            if let result = try context.fetch(fetchRequest).first {
                result.noteText = note
                result.date = date
                result.isDone = isDone
                try context.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
