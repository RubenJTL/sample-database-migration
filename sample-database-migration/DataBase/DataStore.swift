//
//  DataStore.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Foundation
import SQLite

class DataStore {
//    static let sharedInstance = DataStore()

    public private(set) var db: Connection
    private var databaseVersion: Int {
        get {
            do {
                return try Int(db.scalar("PRAGMA user_version") as? Int64 ?? 0)
            } catch {
                print(error)
                return 0
            }
        }
        set {
            do {
                try db.run("PRAGMA user_version = \(newValue)")
            } catch {
                print(error)
            }
        }
    }
    
//    init() {
//        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { fatalError("Unable to locate path for database") }
//
//        do {
//            db = try Connection("\(path)/database.sqlite3")
//
//            db.busyHandler { _ in
//                print("DB BUSY HANDLER called - possible thread contention for database")
//                return true
//            }
//
//            try updateDatabase()
//        } catch {
//            print(error)
//        }
//    }
    
    init() throws {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        else { fatalError("Unable to locate path for database") }
        
        db = try Connection("\(path)/database.sqlite3")
        db.busyHandler { _ in
            print("DB BUSY HANDLER called - possible thread contention for database")
            return true
        }
    }
    
    func updateDatabase() throws {
        if databaseVersion < 1 {
            try db.transaction {
                try CharacterTable.create(db: db)
                
                databaseVersion = 1
            }
        }
    }
}

extension DataStore {
    func updateCharacters(_ characters: [Character]) {
        do {
            try db.transaction {
                try db.run(CharacterTable.table.delete())
                for character in characters {
                    try db.run(CharacterTable.table.insert(or: .replace,
                                                           CharacterTable.id <- Int(character.id),
                        CharacterTable.name <- character.name,
                        CharacterTable.status <- character.status,
                        CharacterTable.gender <- character.gender,
                        CharacterTable.image <- character.image?.absoluteString
                    ))
                }
            }
        } catch {
            print(error)
        }
    }
    
    var characters: [Character] {
        var characters: [Character] = []
        do {
            for row in try db.prepare(CharacterTable.table) {
                characters.append(Character(
                    id: try row.get(CharacterTable.id),
                    name: try row.get(CharacterTable.name),
                    status: try row.get(CharacterTable.status),
                    gender: try row.get(CharacterTable.gender),
                    image: try row.get(CharacterTable.image) ?? "")
                )
            }
        } catch {
            print(error)
        }
        
        return characters
    }
}
