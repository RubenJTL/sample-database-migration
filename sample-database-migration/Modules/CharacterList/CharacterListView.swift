//
//  CharacterList.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel = CharacterListViewModel()
    
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
        CharacterListView()
    }
}
