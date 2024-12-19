//
//  Models.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import Foundation
import SwiftData

@MainActor
class PromptParamsModel: ObservableObject {
    @Published var context = ""
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
