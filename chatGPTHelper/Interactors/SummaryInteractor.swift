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
        guard let chapters = appStateModel?.chapters else { return }

        Task {
            for (index, chapter) in chapters.enumerated().prefix(2) {
                guard let promptInitialText = self.appStateModel?.prompts[.summary]?.value else { return }
                
                async let result = webRepository.fetchChatGPTResponse(prompt: promptInitialText + chapter)
                
                do {
                    let response = try await result
                    let summaryObject = SummaryData(chapterNumber: index, text: response, textFileName: self.appStateModel?.textFileName ?? "")
                    self.appStateModel?.summaries.append(summaryObject)
                    Task(priority: .background) {
                        self.localRepository.save(summaryObject)
                    }
                } catch {
                    print("Failed to fetch summary for a chapter: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func onAppear() {
        guard let appStateModel,
              !appStateModel.isSummaryLocalCacheValid else { return }
        
        let fileName = appStateModel.textFileName
        let predicate = #Predicate<SummaryData> {
            $0.textFileName == fileName
        }
        guard let result: [SummaryData] = localRepository.fetch(withPredicate: predicate) else { return }
        
        DispatchQueue.main.async {
            self.setupText()
        }
        
        appStateModel.isSummaryLocalCacheValid = true
        DispatchQueue.main.async {
            self.appStateModel?.summaries = result
        }
    }
    
    private func removeOldSummaries() {
        DispatchQueue.main.async {
//            self.localRepository.deleteAllSummaries()
            self.appStateModel?.summaries = []
        }
    }
}
