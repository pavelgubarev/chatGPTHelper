//
//  QuoteInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 19.12.2024.
//

import Foundation

final class QuoteInteractor {
    
    let webRepository: WebRepository
    let localRepository: LocalRepository
    
    init(webRepository: WebRepository, localRepository: LocalRepository) {
        self.webRepository = webRepository
        self.localRepository = localRepository
    }
    
    var chapter = ""
    
    private var promptParamsModel: PromptParamsModel?
    
    @Published var imageURL: String = ""

    @MainActor
    func requestQuoteAndIllustration() async -> String {
            let quote = await requestQuote()
            
            let prompt = "Сделай иллюстрацию для этой цитаты: " + quote + "  Вот тебе для контекста текст, из которого цитата: " + chapter
            
            async let result = webRepository.fetchChatGPTImageResponse(prompt: prompt)
            
            do {
                let response = try await result
                print(response)
                return response
            } catch {
                print("Failed to fetch summary for a chapter: \(error)")
                return ""
            }
    }
    
    
    @MainActor
    private func requestQuote() async -> String {
        guard let chapter = promptParamsModel?.chapters.randomElement() else { return "" }
        
        let prompt = (promptParamsModel?.context ?? "") + chapter
        async let result = webRepository.fetchChatGPTResponse(prompt: prompt)
        
        do {
            let response = try await result
            print(response)
            return response
        } catch {
            print("Failed to fetch summary for a chapter: \(error)")
        }
        return ""
    }
    
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }
}
