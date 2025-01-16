//
//  WebRepositoryMock.swift
//  chatGPTHelperTests
//
//  Created by Павел Губарев on 10.01.2025.
//

import Foundation
@testable import chatGPTHelper

final class WebRepositoryMock: WebRepositoryProtocol {
    
    private(set) var isFetchChatGPTResponseCalled = false
    private(set) var isFetchChatGPTImageResponseCalled = false
    private(set) var isConfigureCalled = false
    
    func fetchChatGPTResponse(prompt: String) async throws -> String {
        isFetchChatGPTResponseCalled = true
        return "sample chat response"
    }
    
    func fetchChatGPTImageResponse(prompt: String) async throws -> String {
        isFetchChatGPTImageResponseCalled = true
        return ""
    }
    
    func configure(promptParamsModel: chatGPTHelper.PromptParamsModel) {
        isConfigureCalled = true
    }
}
