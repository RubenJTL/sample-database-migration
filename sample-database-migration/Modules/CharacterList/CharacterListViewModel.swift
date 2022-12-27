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
    
    private let coreDataManager: CoreDataManager
    private let characterListService: CharacterListServiceType
    private let dataStore: DataStore?
    private var cancellables = Set<AnyCancellable>()
    
    init(characters: [Character] = [Character](), characterListService: CharacterListServiceType = CharacterListService(), managedObjectContext: CoreDataManager) {
        self.characters = characters
        self.characterListService = characterListService
        self.coreDataManager = managedObjectContext
        self.dataStore = try? DataStore()

        fetchCharacters()
    }
    
    func fetchCharacters() {
        isLoading = true
        
        if let charactersMO = try? coreDataManager.getAll(CharacterMO.self),  !charactersMO.isEmpty {
            characters = charactersMO.map { Character(characterMO: $0) }
            isLoading = false
        } else {
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
                    self?.coreDataManager.updateOrCreateCharacters(characters)
                }
                .store(in: &cancellables)
        }
        
       
    }
}
