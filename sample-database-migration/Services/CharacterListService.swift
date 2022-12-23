//
//  RickAndMortyListService.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Combine
import Foundation

protocol CharacterListServiceType {
    func getCharacters() -> AnyPublisher<[Character], Error>
}

struct CharacterListService: CharacterListServiceType {

    let session: URLSessionType
    let decoder: JSONDecoder
    
    init(session: URLSessionType = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func getCharacters() -> AnyPublisher<[Character], Error> {
        session.request(urlString: Constants.Network.apiRest + "/character", requestType: .get)
            .decode(type: CharactersResource.self, decoder: decoder)
            .map { $0.results.map { Character(characterDTO: $0) } }
            .eraseToAnyPublisher()
    }
    
}
