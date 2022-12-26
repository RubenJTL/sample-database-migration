//
//  CharacterTable.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Foundation
import SQLite

struct CharacterTable {
    static let table = Table("character")
    static let id = Expression<Int>("id")
    static let name = Expression<String>("name")
    static let status = Expression<String>("status")
    static let gender = Expression<String>("gender")
    static let image = Expression<String?>("image")
    
    static func create(db: Connection) throws {
        try db.run(CharacterTable.table.create(ifNotExists: true) { builder in
            builder.column(id, primaryKey: true)
            builder.column(name)
            builder.column(status)
            builder.column(gender)
            builder.column(image)
        })
    }
}
