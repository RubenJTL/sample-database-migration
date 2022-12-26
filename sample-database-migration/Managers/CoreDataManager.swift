//
//  CoreDataManager.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    static let shared = CoreDataManager()

    init() {
        container = NSPersistentContainer(name: "Sample")
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
}
