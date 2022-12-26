//
//  CharacterMO+CoreDataClass.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 26/12/22.
//
//

import Foundation
import CoreData

@objc(CharacterMO)
public class CharacterMO: NSManagedObject {
    convenience init(character: Character, context: NSManagedObjectContext) {
//        self.init(context: context)
        self.init()
        
        self.id = character.id
        self.name = character.name
        self.gender = character.gender
        self.status = character.status
        self.image = character.image
    }
}
