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
    @Binding var contextText: String
    
    init(context: Binding<String>) {
        self._contextText = context
    }
    
    var body: some View {
        VStack {
            TextField("Enter your note", text: $contextText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: contextText, {
                    saveText()
                }
                )
            Button("fetch") {
                fetchText()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            fetchText()
        }
    }
    
    private func fetchText() {
        if let data = contextData.first {
            contextText = data.text
        }
        print(contextText)
    }
    
    private func saveText() {
        if let existingNote = contextData.first {
            existingNote.text = contextText
        } else {
            // Create a new note if none exists
            let newNote = ContextData(text: contextText)
            modelContext.insert(newNote)
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
