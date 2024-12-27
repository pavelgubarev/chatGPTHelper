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
    @State private var navigationPath = NavigationPath()
    
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
            NavigationStack(path: $navigationPath) {
                if let selectedItem = selectedItem {
                    //TODO перенести инжект?
                    DetailView(selectedItem: selectedItem, navigationPath: $navigationPath)
                        .environmentObject(promptParamsModel)
                        .inject(container)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Select an item")
                        .foregroundColor(.gray)
                }
            }
        }.onAppear() {
            //TODO перенести
            container.set(promptParamsModel: promptParamsModel)
            self.container.localRepository.modelContext = modelContext
        }
    }
}

struct IllustrationDetailViewData: Hashable {
    let id: PersistentIdentifier
}

struct DetailView: View {
    let selectedItem: MenuItem
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    @Environment(\.injected) private var dependencies: DIContainer
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        Group {
            switch selectedItem {
            case .Summary:
                SummaryView()
            case .Quote:
                QuoteView(interactor: dependencies.interactors.quote, navigationPath: $navigationPath)
            case .Context:
                ContextView()
            case .Settings:
                SettingsView()
            }
        }.environmentObject(promptParamsModel)
            .inject(dependencies)
            .onAppear {
                dependencies.interactors.contentView.onAppear()
                print(promptParamsModel.context)
            }
            .navigationDestination(for: IllustrationDetailViewData.self) { illustrationData in
                IllustrationDetailView(data: illustrationData).inject(dependencies)
            }
    }
}

#Preview {
    ContentView(container: DIContainer())
}
