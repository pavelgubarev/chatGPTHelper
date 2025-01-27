//
//  Models.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import Foundation
import SwiftData

enum PromptKeys: CaseIterable, Codable {
    case summary
    case quote
    case prompt
}

class ObservableString: ObservableObject, Equatable {
    @Published var value: String = ""
    
    init(value: String = "") {
        self.value = value
    }
    static func == (lhs: ObservableString, rhs: ObservableString) -> Bool {
        lhs.value == rhs.value
    }    
}

@MainActor
class AppStateModel: ObservableObject {    
    var prompts: [PromptKeys: ObservableString] = [:]

    @Published var mockText = ""
    @Published var isMockEnabled = false
    @Published var summaries = [SummaryData]()
    
    var chapters = [String]()
    
    @Published var textFileName = ""
    
    var isQuoteLocalCacheValid = false
}

@Model
final class SummaryData {
    var textFileName: String
    var chapterNumber: Int
    var text: String
    
    init(chapterNumber: Int, text: String, textFileName: String) {
        self.textFileName = textFileName
        self.chapterNumber = chapterNumber
        self.text = text
    }
}


@Model
final class IllustrationContainer: ObservableObject, Identifiable {
    var textFileName: String
    var quote: String = ""
    var prompt: String = ""
    var imageURL: String = ""
        
    init(quote: String = "", prompt: String = "", imageURL: String = "", textFileName: String) {
        self.textFileName = textFileName
        self.quote = quote
        self.prompt = prompt
        self.imageURL = imageURL
    }

    init(from illustration: Illustration, textFileName: String) {
        self.quote = illustration.quote
        self.imageURL = illustration.imageURL
        self.prompt = illustration.prompt
        self.textFileName = textFileName
    }
    
    func asIllustration() -> Illustration {
        let illustration = Illustration()
        illustration.quote = quote
        illustration.prompt = prompt
        illustration.imageURL = imageURL
        illustration.persistentID = persistentModelID
        return illustration
    }
}


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

