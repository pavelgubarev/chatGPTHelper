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

        illustration.quote = await requestQuote()
        illustration.prompt = await requestPrompt(quote: illustration.quote)
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
        
//
////
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            illustration.quote = "Цитата"
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            illustration.prompt = "Создай атмосферную, кинематографическую иллюстрацию ночной сцены в коридоре загадочного здания. Главный акцент сделай на двух девушках: первая — Катя, молодая, раздумчивая, в тонкой пижаме, укутавшаяся в шаль, ощущает лёгкий холод и замешательство; вторая — Галя, девушка с пронзительным, почти гипнотизирующим взглядом, одетая в строгий, чуть винтажный наряд, держит маленький ночничок с мягким молочным светом. Их окружает длинный, тёмный коридор с загадочными белыми дверьми, дрожащими тенями на стенах и ощущением тайны. Вдалеке едва виден свет из окна соседнего офисного здания, добавляющий атмосферности. Общий стиль иллюстрации — неоновый нуар с элементами сюрреализма, подчёркивающий напряжённость и философскую глубину ситуации."
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            illustration.imageURL = "https://oaidalleapiprodscus.blob.core.windows.net/private/org-tE89vTbqoJnfqTsMl7E1cLze/user-WLrcGnBMvb9KqGlIPl6P4N84/img-MrrurFnDLKeQ2vto2gPaS93U.png?st=2024-12-25T12%3A01%3A51Z&se=2024-12-25T14%3A01%3A51Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=d505667d-d6c1-4a0a-bac7-5c84a87759f8&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2024-12-24T22%3A58%3A14Z&ske=2024-12-25T22%3A58%3A14Z&sks=b&skv=2024-08-04&sig=OjgiyEytnGkaDZgF4X5Ja%2BgPvgm2rXOM3sxiQwC3swI%3D"
//            
//            self.localRepository.downloadAndSaveImage(from: illustration.imageURL) { localURL in
//                
//                guard let localURL else {return}
//                
//            let illustrationContainer = IllustrationContainer()
//            illustrationContainer.quote = illustration.quote
//            illustrationContainer.prompt = illustration.prompt
//            illustrationContainer.imageURL = localURL
//            
//            self.localRepository.save(illustrationContainer)
//            }
//            

//        }
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
    func requestQuote() async -> String {
        var usedQuotes = ""
        //TODO: remove prefix
        _ = illustrationsViewModel.illustrations.map { usedQuotes = usedQuotes + $0.quote.prefix(200) + ", " }
        
        guard let chapter = promptParamsModel?.chapters.randomElement() else { return "" }
        
        self.chapter = chapter
        
        let prompt = (promptParamsModel?.context ?? "") + chapter + "Далее список цитат, которые ты уже выбирал. Не используй их: " + usedQuotes
        
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
 
    @MainActor
    private func requestPrompt(quote: String) async -> String {        
        let prompt = "Сделай промпт для Dall-e для иллюстрации этой цитаты: " + quote + " Цитата взята из этой главы: " + chapter
               
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


