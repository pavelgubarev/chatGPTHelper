//
//  ContentView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI
import SwiftData

enum MenuItem: CaseIterable {
    case Summary
    case Quote
    case Context
    case Settings
}

struct ContentView: View {
    private let container: DIContainer
    @State private var selectedItem: MenuItem? = .Quote
    @StateObject private var promptParamsModel = PromptParamsModel()
    @Environment(\.modelContext) private var modelContext

    init(container: DIContainer) {
        self.container = container
    }
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(MenuItem.allCases, id: \.self, selection: $selectedItem) { item in
                Text(String(describing: item))
            }
            .frame(minWidth: 200)
            .navigationTitle("Menu")
        } detail: {
            // Detail View
            if let selectedItem = selectedItem {
                //TODO перенести инжект?
                DetailView(selectedItem: selectedItem)
                    .environmentObject(promptParamsModel)
                    .inject(container)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Select an item")
                    .foregroundColor(.gray)
            }
        }.onAppear() {            
            //TODO перенести
            self.container.interactors.summary.configure(promptParamsModel: promptParamsModel)
            self.container.interactors.quote.configure(promptParamsModel: promptParamsModel)
            self.container.interactors.contentView.configure(promptParamsModel: promptParamsModel)
            self.container.webRepository.configure(promptParamsModel: promptParamsModel)
            self.container.localRepository.modelContext = modelContext
        }
    }
}

struct DetailView: View {
    let selectedItem: MenuItem
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    @Environment(\.injected) private var dependencies: DIContainer
    
    var body: some View {
        Group {
            switch selectedItem {
            case .Summary:
                SummaryView()
            case .Quote:
                QuoteView(interactor: dependencies.interactors.quote)
            case .Context:
                ContextView()
            case .Settings:
                SettingsView()
            default:
                Text("")
            }
        }.environmentObject(promptParamsModel)
            .inject(dependencies)
            .onAppear {
                dependencies.interactors.contentView.onAppear()
                print(promptParamsModel.context)
            }
    }
}

#Preview {
    ContentView(container: DIContainer())
}
