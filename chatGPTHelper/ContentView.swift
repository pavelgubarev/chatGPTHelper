//
//  ContentView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI
import SwiftData

enum MenuItem: CaseIterable {
    case Read
    case Quote
    case Images
    case Context
    case Settings
}

class PromptParamsModel: ObservableObject {
    @Published var context = ""
    @Published var mockText = ""
    @Published var isMockEnabled = false
}

struct ContentView: View {
    @State private var selectedItem: MenuItem? = .Read
    @StateObject private var promptParamsModel = PromptParamsModel()

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
                   DetailView(selectedItem: selectedItem)
                       .environmentObject(promptParamsModel).frame(maxWidth: .infinity, maxHeight: .infinity)
               } else {
                   Text("Select an item")
                       .foregroundColor(.gray)
               }
           }
       }
}

struct DetailView: View {
    let selectedItem: MenuItem
    @EnvironmentObject private var promptParamsModel: PromptParamsModel

    var body: some View {
        switch selectedItem {
        case .Read:
            ReadView()
        case .Context:
            ContextView().environmentObject(promptParamsModel)
        case .Settings:
            SettingsView().environmentObject(promptParamsModel)
        default:
            Text("")
        }
    }
}

#Preview {
    ContentView()
}
