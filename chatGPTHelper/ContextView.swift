//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftData
import Combine

@Model
final class ContextData {
    @Attribute(.unique) var id: UUID
    var text: String
    
    init(text: String) {
        self.id = UUID()
        self.text = text
    }
}

import SwiftUI

struct ContextView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contextData: [ContextData]
    @EnvironmentObject private var promptParamsModel: PromptParamsModel

//    init(context: Binding<String>) {
//        self._contextText = context
//    }
    
    var body: some View {
        VStack {
            TextField("Enter your note", text: $promptParamsModel.context)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: promptParamsModel.context, {
                    saveText()
                }
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            fetchText()
        }
    }
    
    private func fetchText() {
        if let data = contextData.first {
            promptParamsModel.context = data.text
        }
    }
    
    private func saveText() {
        if let existingData = contextData.first {
            existingData.text = promptParamsModel.context
        } else {
            // Create a new note if none exists
            let newData = ContextData(text: promptParamsModel.context)
            modelContext.insert(newData)
        }
        
        do {
            try modelContext.save()
        } catch {
        }
    }
}

#Preview {
    ReadView()
}
