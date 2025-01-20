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
class PromptParamsModel: ObservableObject {    
    var prompts: [PromptKeys: ObservableString] = [:]

    @Published var mockText = ""
    @Published var isMockEnabled = false
    @Published var summaries = [SummaryData]()
    
    // TODO разделить
    var chapters = [String]()
}

@Model
final class SummaryData {
    @Attribute(.unique) var id: UUID
    var chapterNumber: Int
    var text: String
    
    init(chapterNumber: Int, text: String) {
        self.id = UUID()
        self.chapterNumber = chapterNumber
        self.text = text
    }
}


@Model
final class IllustrationContainer: ObservableObject, Identifiable {
    @Attribute(.unique) var id: UUID

    var quote: String = ""
    var prompt: String = ""
    var imageURL: String = ""
        
    init(quote: String = "", prompt: String = "", imageURL: String = "") {
        self.id = UUID()
        self.quote = quote
        self.prompt = prompt
        self.imageURL = imageURL
    }
    
    func getIllustration() -> Illustration {
        let illustration = Illustration()
        illustration.quote = quote
        illustration.prompt = prompt
        illustration.imageURL = imageURL
        illustration.persistentID = id
        return illustration
    }
}
