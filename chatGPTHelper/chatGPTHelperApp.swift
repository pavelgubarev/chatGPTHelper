//
//  chatGPTHelperApp.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI
import SwiftData

@main
struct chatGPTHelperApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.isRunningTests == false {
                let assembly = Assembly()
                ContentView(container:  DIContainer(
                    interactors: assembly.makeAllInteractors(),
                    webRepository: assembly.webRepository,
                    localRepository: assembly.localRepository
                )
                )
            }
        }
        .modelContainer(for: [ContextData.self, MockedResponseData.self, SummaryData.self, IllustrationContainer.self])
    }
}
