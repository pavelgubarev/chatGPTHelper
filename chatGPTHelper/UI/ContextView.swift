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
    @EnvironmentObject private var appStateModel: AppStateModel
    @EnvironmentObject private var dependencies: DIContainer

    var body: some View {
        VStack {
            ForEach(PromptKeys.allCases, id: \.self) { key in
                if let prompt = appStateModel.prompts[key] {
                    Text(String(describing: key))
                    TextEditor(
                        text: Binding(
                            get: { prompt.value },
                            set: {
                                prompt.value = $0
                                saveText()
                            }
                        )
                    )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if appStateModel.prompts.isEmpty {
                fetchPromptsTexts()
            }
        }
    }

    // TODO: TO BE MOVED TO INTERACTOR
    private func fetchPromptsTexts() {
        if let data = promptsData.first {
            for (key, prompt) in data.prompts {
                appStateModel.prompts[key] = ObservableString(value: prompt)
            }
        }
    }
    
    private func saveText() {
        if let existingData = promptsData.first {
            for (key, prompt) in appStateModel.prompts {
                existingData.prompts[key] = prompt.value
            }
        } else {
            let newData = PromptsData(prompts: appStateModel.prompts)
            modelContext.insert(newData)
        }
        do {
            try modelContext.save()
        } catch {
        }
    }
}
