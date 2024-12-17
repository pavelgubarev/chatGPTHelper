//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI

final class Interactor: ObservableObject {
    var wholeText: String = ""
    var chapters = [String]()
    
    @Published var summaries: [String] = []

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
        chapters = wholeText.components(separatedBy: "##").filter { $0.count > 10 }
    }
    
    func buildRequestForAQuote(_ promptParamsModel: PromptParamsModel) -> String? {
        guard let chapter = chapters.randomElement() else { return nil }
        
        return promptParamsModel.context + chapter
    }
    
    func requestAllSummaries() {        
        Task {
            for chapter in chapters.prefix(10) {
                async let result = fetchChatGPTResponse(prompt: "Пожалуйста, сделай краткое содержание этой главы, начни с названия главы и перечисли основные события списком: " + chapter)

//                async let result = fakeQ()
                
                do {
                    let response = try await result
                    DispatchQueue.main.async { [weak self] in
                        self?.summaries.append(response)
                    }
                } catch {
                    print("Failed to fetch summary for a chapter: \(error)")
                }
            }
        }
    }
    func fakeQ() async throws -> String {
        do {
                try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            } catch {
            }
        return "another summary"
    }
    
}
