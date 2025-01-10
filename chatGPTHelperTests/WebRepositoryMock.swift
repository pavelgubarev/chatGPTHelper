//
//  WebRepositoryMock.swift
//  chatGPTHelperTests
//
//  Created by Павел Губарев on 10.01.2025.
//

import Foundation
@testable import chatGPTHelper

final class WebRepositoryMock: WebRepositoryProtocol {

    func fetchChatGPTResponse(prompt: String) async throws -> String {
        return ""
    }
    
    func fetchChatGPTImageResponse(prompt: String) async throws -> String {
        return ""
    }
    
    func configure(promptParamsModel: chatGPTHelper.PromptParamsModel) {
    }
}
