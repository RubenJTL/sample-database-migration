//
//  CoreDataManager.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Foundation
import CoreData

enum CoreDataFetchError: Error {
    case notFound
}

class CoreDataManager: ObservableObject {
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static let shared = CoreDataManager()

    init() {
        container = NSPersistentContainer(name: "sampleModel")
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }
    
    func getAll<T: NSManagedObject>(_ classType: T.Type, withSortDescriptors sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        let request = classType.fetchRequest()
        request.sortDescriptors = sortDescriptors
        
        guard let results = try? context.fetch(request) as? [T] else {
            throw CoreDataFetchError.notFound
        }
        
        return results
    }
    
    func get<T: NSManagedObject, ID>(_ classType: T.Type, withId id: ID) throws -> T {
        let request = classType.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        // Assuming that we are running in the appropriate thread for the passed in context
        guard let result = try? context.fetch(request).first as? T else {
            throw CoreDataFetchError.notFound
        }
        
        return result
    }
    
    func updateOrCreateCharacters(_ characters: [Character]) {
        for character in characters {
            do {
                do {
                    let characterMO = try get(CharacterMO.self, withId: character.id)
                    try characterMO.update(with: character)
                } catch {
                    let characterMO = CharacterMO(character: character, context: context)
                    try characterMO.save()
                }
            } catch {
                print("Failed to fetch character:", error)
            }
        }
    }
}
