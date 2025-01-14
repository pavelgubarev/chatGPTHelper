//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftData
import Combine

@Model
final class PromptsData {
    @Attribute(.unique) var id: UUID
    var prompts: [PromptKeys: String] = [:]
    
    init(prompts: [PromptKeys: ObservableString]) {
        self.id = UUID()
        for (key, prompt) in prompts {
            self.prompts[key] = prompt.value
        }
    }
}

import SwiftUI

struct ContextView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var promptsData: [PromptsData]
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    @EnvironmentObject private var dependencies: DIContainer

    var body: some View {
        VStack {
            ForEach(PromptKeys.allCases, id: \.self) { key in
                //TODO: better unwrapping
                    TextEditor(text: Binding(
                        get: { promptParamsModel.prompts[key]?.value ?? "" },
                        set: {
                            promptParamsModel.prompts[key]?.value = $0
                            saveText()
                        }
                    )
                    )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
//                        .onChange(of: promptParamsModel.prompts[key] ?? ObservableString()) { newValue in 
//                            
//                        }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if promptParamsModel.prompts.isEmpty {
                fetchPromptsTexts()
            }
        }
    }
    
    private func fetchPromptsTexts() {
        if let data = promptsData.first {
            for (key, prompt) in data.prompts {
                promptParamsModel.prompts[key] = ObservableString(value: prompt)
            }
        }
    }
    
    private func saveText() {
        if let existingData = promptsData.first {
            for (key, prompt) in promptParamsModel.prompts {
                existingData.prompts[key] = prompt.value
            }
        } else {
            let newData = PromptsData(prompts: promptParamsModel.prompts)
            modelContext.insert(newData)
        }
        do {
            try modelContext.save()
        } catch {
        }
    }
}
