//
//  CharacterMO+CoreDataProperties.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 26/12/22.
//
//

import Foundation
import CoreData


extension CharacterMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterMO> {
        return NSFetchRequest<CharacterMO>(entityName: "CharacterMO")
    }

    @NSManaged public var gender: String
    @NSManaged public var id: Int
    @NSManaged public var image: URL?
    @NSManaged public var name: String
    @NSManaged public var status: String

}

extension CharacterMO : Identifiable {

}
