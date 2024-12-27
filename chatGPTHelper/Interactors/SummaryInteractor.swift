//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

final class SummaryInteractor: Interactor {
    
    @MainActor
    func requestAllSummaries() {
        DispatchQueue.main.async {
            self.localRepository.deleteAllSummaries()
            self.promptParamsModel?.summaries = []
        }
        Task {            
            setupText()
            guard let chapters = promptParamsModel?.chapters else { return }
            
            for (index, chapter) in chapters.enumerated().prefix(2) {
                async let result = webRepository.fetchChatGPTResponse(prompt: "Пожалуйста, сделай краткое содержание этой главы, начни с названия главы и перечисли основные события списком: " + chapter)
                
                do {
                    let response = try await result
                    let summaryObject = SummaryData(chapterNumber: index, text: response)
                    DispatchQueue.main.async {
                        print("append")
                        self.promptParamsModel?.summaries.append(summaryObject)
                        self.localRepository.save(summaryObject)
                    }
                } catch {
                    print("Failed to fetch summary for a chapter: \(error)")
                }
            }
        }
    }
          
    func onAppear() {
        guard let result: [SummaryData] = localRepository.fetch() else { return }
        DispatchQueue.main.async {
            self.promptParamsModel?.summaries = result
        }
    }    
}
