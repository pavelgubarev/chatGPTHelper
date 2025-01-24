//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftData
import Combine

@Model
final class MockedResponseData {
    @Attribute(.unique) var id: UUID
    var text: String
    var isEnabled: Bool
    
    init(text: String, isEnabled: Bool) {
        self.id = UUID()
        self.text = text
        self.isEnabled = isEnabled
    }
}

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var dependencies: DIContainer
    @Environment(\.modelContext) private var modelContext
    @Query private var mockedResponseData: [MockedResponseData]
    @EnvironmentObject private var appStateModel: AppStateModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Should use mock")
                    Picker("Switch On/Off", selection: $appStateModel.isMockEnabled) {
                        Text("On")
                            .tag(true)
                        Text("Off")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                Text("\(geometry.size.height)")
                TextEditor(text: $appStateModel.mockText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: geometry.size.height * 0.5)
                    .onChange(of: appStateModel.mockText, {
                        saveText()
                    }
                    )
                Spacer()
                Button("fetch") {
                    fetchText()
                }
            }.padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    fetchText()
                }
        }
    }
    
    private func fetchText() {
        if let data = mockedResponseData.first {
            appStateModel.mockText = data.text
        }
        print(appStateModel.mockText)
    }
    
    private func saveText() {
        if let existingData = mockedResponseData.first {
            existingData.text = appStateModel.mockText
            existingData.isEnabled = appStateModel.isMockEnabled
        } else {
            // Create a new note if none exists
            let newData = MockedResponseData(text: appStateModel.mockText, isEnabled: appStateModel.isMockEnabled)
            modelContext.insert(newData)
        }
        
        do {
            try modelContext.save()
            print("Note saved successfully.")
        } catch {
            print("Failed to save note: \(error.localizedDescription)")
        }
    }
}
