//
//  ContentViewInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation
import SwiftData
import SwiftUI

final class ContentViewInteractor {
    private var promptParamsModel: PromptParamsModel?

    let webRepository: WebRepository
    let localRepository: LocalRepository
    
    init(webRepository: WebRepository, localRepository: LocalRepository) {
        self.webRepository = webRepository
        self.localRepository = localRepository
    }
    
    @MainActor
    func onAppear() {
        if let data: [ContextData] = localRepository.fetch() {
            if let context = data.first {
                promptParamsModel?.context = context.text
            }
        }
    }
    
    //TODO: Рефакторинг
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }
}
