//
//  Request.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import Foundation
import SwiftData
import SwiftUI

protocol WebRepositoryProtocol {
    func fetchChatGPTResponse(prompt: String) async throws -> String

    func fetchChatGPTImageResponse(prompt: String) async throws -> String

    func configure(promptParamsModel: PromptParamsModel)
}

final class WebRepository: WebRepositoryProtocol {

    private var promptParamsModel: PromptParamsModel?

    func fetchChatGPTResponse(prompt: String) async throws -> String {
        let requestBody = ChatGPTRequest(
            model: "chatgpt-4o-latest",
            messages: [Message(role: "user", content: prompt)],
            max_tokens: 1500
        )

        let response: ChatGPTResponse = try await fetchOpenAIResponse(
            requestBody: requestBody,
            responseType: ChatGPTResponse.self,
            url: "https://api.openai.com/v1/chat/completions"
        )

        if let error = response.error {
            throw NSError(domain: "OpenAIAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: error.message])
        }

        return response.choices.first?.message.content ?? "No response received."
    }

    func fetchChatGPTImageResponse(prompt: String) async throws -> String {
        let requestBody = ImageGenerationRequest(
            model: "dall-e-3",
            prompt: prompt,
            n: 1,
            size: "1024x1024"
        )

        let response: ImageGenerationResponse = try await fetchOpenAIResponse(
            requestBody: requestBody,
            responseType: ImageGenerationResponse.self,
            url: "https://api.openai.com/v1/images/generations"
        )

        if let error = response.error {
            throw NSError(domain: "OpenAIAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: error.message])
        }

        return response.data.first?.url ?? "No image URL received."
    }
    
    func configure(promptParamsModel: PromptParamsModel) {
        self.promptParamsModel = promptParamsModel
    }
    
    private func fetchOpenAIResponse<RequestBody: Codable, ResponseBody: Codable>(
        requestBody: RequestBody,
        responseType: ResponseBody.Type,
        url: String
    ) async throws -> ResponseBody {
        let jsonData = try JSONEncoder().encode(requestBody)

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.APIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "No response body")")

        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
        return decodedResponse
    }

}
