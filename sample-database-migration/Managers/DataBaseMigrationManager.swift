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
//        guard let database = DataStore.sharedInstance, database.db != nil
//        else { return nil }
        self.coreDataManager = coreDataManager
        guard let database = try? DataStore()
        else { return nil }
        
        self.database = database
        
    }
    
    func migrationDatabase() async  {
        await CoreDataManager.shared.container.performBackgroundTask { [weak self] context in
            
            guard let characters = self?.database.characters
            else { return }
            
            for character in characters {
                
            }
        }
    }
}
