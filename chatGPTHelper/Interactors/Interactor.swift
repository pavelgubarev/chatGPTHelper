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
}
