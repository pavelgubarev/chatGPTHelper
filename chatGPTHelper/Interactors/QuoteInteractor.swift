//
//  QuoteInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 19.12.2024.
//

import Foundation
import SwiftData

protocol QuoteInteractorProtocol: Interactor {
    var illustrationsViewModel: IllustrationsViewModel { get }
    func didTapGetIllustration() async
    func onAppear()
}
    
class Illustration: ObservableObject, Identifiable {    
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

final class QuoteInteractor: Interactor, QuoteInteractorProtocol {
        
    let illustrationsViewModel = IllustrationsViewModel()
    
    private var chapter = ""
    private var isLocalCacheLoaded = false
    
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
            let illustrationContainer = IllustrationContainer(from: illustration)
            self.localRepository.save(illustrationContainer)
            illustration.persistentID = illustrationContainer.persistentModelID
        }
    }

    @MainActor
    private func requestImage(prompt: String) async -> String {
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
    private func requestQuote() async -> String? {
        var usedQuotes = ""
        _ = illustrationsViewModel.illustrations.map { usedQuotes = usedQuotes + $0.quote.prefix(300) + ", " }
        
        guard let chapter = promptParamsModel?.chapters.randomElement() else { return nil }
        
        self.chapter = chapter
        
        guard let promptInitialText = promptParamsModel?.prompts[.quote]?.value else { return nil }
        
        let prompt = promptInitialText + chapter + "Далее список цитат, которые ты уже выбирал. Не используй их: " + usedQuotes
        
        async let result = webRepository.fetchChatGPTResponse(prompt: prompt)
        
        do {
            return try await result
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
        guard !isLocalCacheLoaded,
              let result: [IllustrationContainer] = localRepository.fetch() else { return }
        
        DispatchQueue.main.async {
            self.setupText()
        }
        
        isLocalCacheLoaded = true
        DispatchQueue.main.async {
            for savedItem in result {
                let illustration = savedItem.asIllustration()
                self.illustrationsViewModel.illustrations.insert(illustration, at: .zero)
            }
        }
    }
}
