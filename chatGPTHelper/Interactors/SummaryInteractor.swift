//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

protocol SummaryInteractorProtocol: Interactor {
    func requestAllSummaries()
    func onAppear()
}

final class SummaryInteractor: Interactor, SummaryInteractorProtocol {
    
    @MainActor
    func requestAllSummaries() {        
        removeOldSummaries()
        setupText()
        guard let chapters = promptParamsModel?.chapters else { return }

        Task {
            for (index, chapter) in chapters.enumerated().prefix(2) {
                async let result = webRepository.fetchChatGPTResponse(prompt: "Пожалуйста, сделай краткое содержание этой главы, начни с названия главы и перечисли основные события списком: " + chapter)
                
                do {
                    let response = try await result
                    let summaryObject = SummaryData(chapterNumber: index, text: response)
                    DispatchQueue.main.async {
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
    
    private func removeOldSummaries() {
        DispatchQueue.main.async {
            self.localRepository.deleteAllSummaries()
            self.promptParamsModel?.summaries = []
        }
    }
}
