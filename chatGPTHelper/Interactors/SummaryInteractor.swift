//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class SummaryData {
    @Attribute(.unique) var id: UUID
    var text: String
    
    init(text: String) {
        self.id = UUID()
        self.text = text
    }
}

final class SummaryInteractor: ObservableObject {
    
    @Query private var contextData: [SummaryData]
    var modelContext: ModelContext?

    let repository: Repository
    
    var wholeText: String = ""
    var chapters = [String]()
    
    private var promptParamsModel: PromptParamsModel?

    init(repository: Repository) {
        self.repository = repository
    }
    
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }

    func setupText() {
        do {
            if let fileURL = Bundle.main.url(forResource: "Katya", withExtension: "txt") {
                wholeText = try String(contentsOf: fileURL, encoding: .utf8)
            } else {
                print("File not found in the bundle.")
            }
        } catch {
            print("Error reading file: \(error)")
        }
        chapters = wholeText.components(separatedBy: "##").filter { $0.count > 10 }
    }
    
    @MainActor
    func buildRequestForAQuote(_ promptParamsModel: PromptParamsModel) -> String? {
        guard let chapter = chapters.randomElement() else { return nil }
        
        return promptParamsModel.context + chapter
    }
    
    @MainActor
    func requestAllSummaries() {
        DispatchQueue.main.async {
            // TODO: добавить очистку в хранилище
            self.promptParamsModel?.summaries = []
        }
        Task {
            for chapter in chapters.prefix(10) {
                async let result = repository.fetchChatGPTResponse(prompt: "Пожалуйста, сделай краткое содержание этой главы, начни с названия главы и перечисли основные события списком: " + chapter)

//                async let result = fakeQ()
                
                do {
                    let response = try await result
                    DispatchQueue.main.async {
                        print("append")
                        self.promptParamsModel?.summaries.append(response)
                    }
                    self.save(summary: response)
                } catch {
                    print("Failed to fetch summary for a chapter: \(error)")
                }
            }
        }
    }
    
    func fakeQ() async throws -> String {
        do {
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            } catch {
            }
        return "another summary"
    }
    
    private func save(summary: String) {
        let newData = SummaryData(text: summary)
        print(modelContext)
        modelContext?.insert(newData)
        do {
            print("save")
            try modelContext?.save()
        } catch {
            print("there was an error")
            //TODO
        }
    }
        
    func onAppear() {
            
            print(self.contextData)
            
            self.contextData.forEach { data in
                // TODO
                DispatchQueue.main.async {
                self.promptParamsModel?.summaries.append(data.text)
            }
        }
    }
    
}
