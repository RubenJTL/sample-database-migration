//
//  CharacterMO+CoreDataProperties.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 26/12/22.
//
//

import Foundation
import CoreData


protocol CoreDataBaseModel {
    func save() throws
    func delete() throws
}

extension CharacterMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterMO> {
        return NSFetchRequest<CharacterMO>(entityName: "CharacterMO")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var gender: String?
    @NSManaged public var image: URL?

    @discardableResult
    convenience init(character: Character, context: NSManagedObjectContext) {
        self.init(context: context)
        
        id = Int32(character.id)
        name = character.name
        status = character.status
        gender = character.gender
        image = character.image
    }
}

extension CharacterMO : Identifiable {

}


extension CharacterMO: CoreDataBaseModel {
    func save() throws {
        try self.managedObjectContext?.save()
    }
    
    func delete() throws {
        self.managedObjectContext?.delete(self)
    }
    
    func update(with character: Character) throws {
        id = Int32(character.id)
        name = character.name
        status = character.status
        gender = character.gender
        image = character.image
        
        try save()
    }
}
