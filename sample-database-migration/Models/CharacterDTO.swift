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
//        image = characterDTO.image
        image = URL(string: characterDTO.image)
    }
}
