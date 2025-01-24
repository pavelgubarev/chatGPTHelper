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
    
    var isQuoteLocalCacheValid = false
}

@Model
final class SummaryData {
    var chapterNumber: Int
    var text: String
    
    init(chapterNumber: Int, text: String) {
        self.chapterNumber = chapterNumber
        self.text = text
    }
}


@Model
final class IllustrationContainer: ObservableObject, Identifiable {
    var quote: String = ""
    var prompt: String = ""
    var imageURL: String = ""
        
    init(quote: String = "", prompt: String = "", imageURL: String = "") {
        self.quote = quote
        self.prompt = prompt
        self.imageURL = imageURL
    }

    init(from illustration: Illustration) {
        self.quote = illustration.quote
        self.imageURL = illustration.imageURL
        self.prompt = illustration.prompt
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
