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
    @Environment(\.modelContext) private var modelContext
    @Query private var mockedResponseData: [MockedResponseData]
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    
    
    //    init(text: Binding<String>, isMockEnabled: Binding<Bool>) {
    //        self._mockText = text
    //        self._isMockEnabled = isMockEnabled
    //    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Should use mock")
                    Picker("Switch On/Off", selection: $promptParamsModel.isMockEnabled) {
                        Text("On")
                            .tag(true)
                        Text("Off")
                            .tag(false)
                    }
                    .pickerStyle(.segmented)
                }
                Text("\(geometry.size.height)")
                TextEditor(text: $promptParamsModel.mockText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: geometry.size.height * 0.5)
                    .onChange(of: promptParamsModel.mockText, {
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
            promptParamsModel.mockText = data.text
        }
        print(promptParamsModel.mockText)
    }
    
    private func saveText() {
        if let existingData = mockedResponseData.first {
            existingData.text = promptParamsModel.mockText
            existingData.isEnabled = promptParamsModel.isMockEnabled
        } else {
            // Create a new note if none exists
            let newData = MockedResponseData(text: promptParamsModel.mockText, isEnabled: promptParamsModel.isMockEnabled)
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

#Preview {
    ReadView()
}
