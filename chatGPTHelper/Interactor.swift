//
//  Interactor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 16.12.2024.
//

import Foundation
import SwiftUI

final class Interactor {
    var wholeText: String = ""
    var chapters = [String]()

    func prepare() {
        do {
            if let fileURL = Bundle.main.url(forResource: "Katya", withExtension: "txt") {
                wholeText = try String(contentsOf: fileURL, encoding: .utf8)
            } else {
                print("File not found in the bundle.")
            }
        } catch {
            print("Error reading file: \(error)")
        }
        chapters = wholeText.components(separatedBy: "##")
    }
    
    func buildRequest(_ promptParamsModel: PromptParamsModel) -> String? {
        guard let chapter = chapters.randomElement() else { return nil }
        
        return promptParamsModel.context + chapter
    }
}
