//
//  RepositoryHolder.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation

class Interactor {
        
    let webRepository: WebRepository
    let localRepository: LocalRepository

    var promptParamsModel: PromptParamsModel?

    init(webRepository: WebRepository, localRepository: LocalRepository) {
        self.webRepository = webRepository
        self.localRepository = localRepository
    }
    
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }
            
    //TODO вынести в хелпер
    @MainActor
    func setupText() {        
        var wholeText: String = ""

        do {
            if let fileURL = Bundle.main.url(forResource: "Katya", withExtension: "txt") {
                wholeText = try String(contentsOf: fileURL, encoding: .utf8)
            } else {
                print("File not found in the bundle.")
            }
        } catch {
            print("Error reading file: \(error)")
        }
        promptParamsModel?.chapters = wholeText.components(separatedBy: "##").filter { $0.count > 10 }
    }
}
