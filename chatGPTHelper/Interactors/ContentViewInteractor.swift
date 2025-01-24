//
//  ContextViewInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation
import SwiftData
import SwiftUI

final class ContentViewInteractor: Interactor {

    @MainActor
    func onAppear() {
        if let data: [PromptsData] = localRepository.fetch() {
            if let promptsData = data.first {
                for (key, prompt) in promptsData.prompts {
                    appStateModel?.prompts[key] = ObservableString(value: prompt)
                }
            } else {
                //TODO: set correct default values
                for key in PromptKeys.allCases {
                    appStateModel?.prompts[key] = ObservableString(value: "default")
                }
            }
        }
    }
}
