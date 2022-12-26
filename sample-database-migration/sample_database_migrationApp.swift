//
//  sample_database_migrationApp.swift
//  sample-database-migration
//
//  Created by Ruben Torres on 23/12/22.
//

import SwiftUI

@main
struct sample_database_migrationApp: App {
    @StateObject private var dataController = CoreDataManager()

    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: CharacterListViewModel(managedObjectContext: dataController.context))
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
