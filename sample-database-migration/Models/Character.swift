//
//  CharacterDTO.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Foundation

struct CharacterDTO: Codable {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let image: String
}

struct CharactersResource: Codable {
    let next: String?
    let results: [CharacterDTO]
}

struct Character {
    let id: Int
    let name: String
    let status: String
    let gender: String
    let image: URL?
    
    init(characterDTO: CharacterDTO) {
        id = characterDTO.id
        name = characterDTO.name
        status = characterDTO.status
        gender = characterDTO.gender
        image = URL(string: characterDTO.image)
    }
    
    init(characterMO: CharacterMO) {
        id = Int(characterMO.id)
        name = characterMO.name ?? ""
        status = characterMO.status ?? ""
        gender = characterMO.gender ?? ""
        image = characterMO.image
    }

    init(id: Int, name: String, status: String, gender: String, image: String) {
        self.id = id
        self.name = name
        self.status = status
        self.gender = gender
        self.image = URL(string: image)
    }
}
