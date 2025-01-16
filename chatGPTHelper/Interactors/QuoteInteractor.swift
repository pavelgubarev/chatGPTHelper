//
//  QuoteInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 19.12.2024.
//

import Foundation
import SwiftData
    
class Illustration: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var quote: String
    @Published var prompt: String
    @Published var imageURL: String
    var persistentID: PersistentIdentifier?
    
    init() {
        quote = ""
        prompt = ""
        imageURL = ""
    }
}

final class IllustrationsViewModel: ObservableObject {
    @Published var illustrations = [Illustration]()
}

final class QuoteInteractor: Interactor {

    var chapter = ""
        
    let illustrationsViewModel = IllustrationsViewModel()
    
    @MainActor
    func didTapGetIllustration() async {
        let illustration = Illustration()
        illustrationsViewModel.illustrations.insert(illustration, at: .zero)

        guard let quote = await requestQuote() else { return }
        
        illustration.quote = quote
        
        guard let promptForImage = await requestPrompt(quote: illustration.quote) else { return }
        
        illustration.prompt = promptForImage
        let remoteImageURL = await requestImage(prompt: illustration.prompt)

        self.localRepository.downloadAndSaveImage(from: remoteImageURL) { localURL in
            guard let localURL else { return }
            
            illustration.imageURL = localURL
            
            let illustrationContainer = IllustrationContainer()
            illustrationContainer.quote = illustration.quote
            illustrationContainer.prompt = illustration.prompt
            illustrationContainer.imageURL = localURL
            
            self.localRepository.save(illustrationContainer)
        }    
    }

    @MainActor
    func requestImage(prompt: String) async -> String {
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
    func requestQuote() async -> String? {
        var usedQuotes = ""
        //TODO: remove prefix
        _ = illustrationsViewModel.illustrations.map { usedQuotes = usedQuotes + $0.quote.prefix(200) + ", " }
        
        guard let chapter = promptParamsModel?.chapters.randomElement() else { return nil }
        
        self.chapter = chapter
        
        guard let promptInitialText = promptParamsModel?.prompts[.quote]?.value else { return nil }
        
        let prompt = promptInitialText + chapter + "Далее список цитат, которые ты уже выбирал. Не используй их: " + usedQuotes
        
        async let result = webRepository.fetchChatGPTResponse(prompt: prompt)
        
        do {
            let response = try await result
            return response
        } catch {
            print("Failed to fetch summary for a chapter: \(error)")
            return nil
        }
    }
 
    @MainActor
    private func requestPrompt(quote: String) async -> String? {
        guard let promptInitialText = promptParamsModel?.prompts[.prompt]?.value else { return nil }
        let prompt = promptInitialText + quote + " Цитата взята из этой главы: " + chapter
               
        async let result = webRepository.fetchChatGPTResponse(prompt: prompt)
        
        do {
            let response = try await result
            print(response)
            return response
        } catch {
            print("Failed to fetch summary for a chapter: \(error)")
            return nil
        }
    }

    func onAppear() {
        illustrationsViewModel.illustrations = []
        guard let result: [IllustrationContainer] = localRepository.fetch() else { return }
        DispatchQueue.main.async {
            for savedItem in result {
                let illustration = Illustration()
                illustration.quote = savedItem.quote
                illustration.prompt = savedItem.prompt
                illustration.imageURL = savedItem.imageURL
                illustration.persistentID = savedItem.persistentModelID
                self.illustrationsViewModel.illustrations.insert(illustration, at: .zero)
            }
        }
    }
}


