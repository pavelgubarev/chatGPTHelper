//
//  Models.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 10.01.2025.
//

import Foundation

struct APIError: Codable {
    let message: String
    let type: String
    let code: String
}

struct ChatGPTRequest: Codable {
    let model: String
    let messages: [Message]
    let max_tokens: Int
}

struct Message: Codable {
    let role: String
    let content: String
}

struct ChatGPTResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    let choices: [Choice]
    let error: APIError?
}

struct ImageGenerationRequest: Codable {
    let model: String
    let prompt: String
    let n: Int
    let size: String
}

struct ImageGenerationResponse: Codable {
    struct Data: Codable {
        let url: String
    }
    let data: [Data]
    let error: APIError?
}
