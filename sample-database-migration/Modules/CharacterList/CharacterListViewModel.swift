//
//  CharacterListViewModel.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import Combine
import Foundation
import SwiftUI
import CoreData

final class CharacterListViewModel: ObservableObject {
    @Published var characters: [Character]
    @Published var isLoading = false
    
    private let managedObjectContext: NSManagedObjectContext
    private let characterListService: CharacterListServiceType
    private let dataStore: DataStore?
    private var cancellables = Set<AnyCancellable>()
    
    init(characters: [Character] = [Character](), characterListService: CharacterListServiceType = CharacterListService(), managedObjectContext: NSManagedObjectContext) {
        self.characters = characters
        self.characterListService = characterListService
        self.managedObjectContext = managedObjectContext
        self.dataStore = try? DataStore()
        if let storedCharacters = dataStore?.characters, !storedCharacters.isEmpty {
            self.characters = storedCharacters
        } else {
            fetchCharacters()
        }
    }
    
    func fetchCharacters() {
        isLoading = true
        characterListService.getCharacters()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        self?.isLoading = false
                    case .failure(let error):
                        print(error)
                        self?.isLoading = false
                }
            } receiveValue: { [weak self] characters in
                self?.characters = characters
                self?.dataStore?.updateCharacters(characters)
            }
            .store(in: &cancellables)
    }
}
