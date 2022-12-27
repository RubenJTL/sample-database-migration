//
//  DataBaseMigrationManager.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 26/12/22.
//

import Foundation
import CoreData
import SQLite

class DataBaseMigrationManager {
    private let database: DataStore
    private let coreDataManager: CoreDataManager
    
    init? (coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        guard let database = try? DataStore()
        else { return nil }
        
        self.database = database
        
    }
    
    func migrationDatabase() async  {
        await coreDataManager.container.performBackgroundTask { [weak self] context in
            
            guard let characters = self?.database.characters
            else { return }
            
            self?.coreDataManager.updateOrCreateCharacters(characters)
            
            guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            else { fatalError("Unable to locate path for database") }
        
            let filemManager = FileManager.default
            do {
                let fileURL = NSURL(fileURLWithPath: "\(path)/database.sqlite3")
                try filemManager.removeItem(at: fileURL as URL)
                print("Database Deleted!")
            } catch {
                print("Error on Delete Database!!!")
            }
        }
    }
}
