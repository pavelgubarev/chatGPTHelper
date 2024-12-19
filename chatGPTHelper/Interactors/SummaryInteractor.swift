//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI
import SwiftData

final class SummaryInteractor {

    let webRepository: WebRepository
    let localRepository: LocalRepository

    var modelContext: ModelContext?

    private var promptParamsModel: PromptParamsModel?

    var wholeText: String = ""
    
    
    init(webRepository: WebRepository, localRepository: LocalRepository) {
        self.webRepository = webRepository
        self.localRepository = localRepository
    }
    
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }
    
    //TODO вынести в хелпер
    @MainActor
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
        promptParamsModel?.chapters = wholeText.components(separatedBy: "##").filter { $0.count > 10 }
    }
    
    @MainActor
    func requestAllSummaries() {
        DispatchQueue.main.async {
            self.localRepository.deleteAllSummaries()
            self.promptParamsModel?.summaries = []
        }
        Task {
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
        guard let result = localRepository.fetchSummaries() else { return }
        DispatchQueue.main.async {
            self.promptParamsModel?.summaries = result
        }
    }
    
}
