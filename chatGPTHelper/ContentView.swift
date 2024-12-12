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

struct ContentView: View {
    @State private var selectedItem: MenuItem? = .Read
    @State var context: String
    
    init() {
        context = ""
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
                   DetailView(selectedItem: selectedItem, context: context)
               } else {
                   Text("Select an item")
                       .foregroundColor(.gray)
               }
           }
       }
}

struct DetailView: View {
    let selectedItem: MenuItem
    @State var context: String
    
    var body: some View {
        switch selectedItem {
        case .Read:
            ReadView()
        case .Context:
            ContextView(context: $context).modelContainer(for: [ContextData.self])
        default:
            Text("")
        }
    }
}

#Preview {
    ContentView()
}
