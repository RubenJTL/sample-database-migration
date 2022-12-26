//
//  CharacterList.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import SwiftUI

struct CharacterListView: View {
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
        if viewModel.isLoading {
            ProgressView()
        } else {
            List(viewModel.characters, id: \.id) { character in
                Text(character.name)
            }
        }
    }
}

struct CharacterList_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.context
        let viewModel = CharacterListViewModel(managedObjectContext: context)
        CharacterListView(viewModel: viewModel)
    }
}
