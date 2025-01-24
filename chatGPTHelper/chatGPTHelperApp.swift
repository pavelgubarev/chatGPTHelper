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
        .modelContainer(for: [PromptsData.self, MockedResponseData.self, SummaryData.self, IllustrationContainer.self])
    }
}
