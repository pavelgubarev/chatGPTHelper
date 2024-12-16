//
//  Request.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import Foundation
import SwiftData
import SwiftUI

struct APIError: Codable {
    let message: String
    let type: String
    let code: String
}

// Define the structure of your request body
struct ChatGPTRequest: Codable {
    let model: String
    let messages: [Message]
    let max_tokens: Int
}

// Define the structure of a single message
struct Message: Codable {
    let role: String
    let content: String
}

// Define the structure of the response
struct ChatGPTResponse: Codable {
    struct Choice: Codable {
        let message: Message
    }
    let choices: [Choice]
    let error: APIError?
}

// Async function to call ChatGPT API
func fetchChatGPTResponse(prompt: String) async throws -> String {
    
    @EnvironmentObject var promptParamsModel: PromptParamsModel
    
//    guard !promptParamsModel.isMockEnabled else {
//        return promptParamsModel.mockText
//    }
    
    // Your API URL and Key
    let apiURL = "https://api.openai.com/v1/chat/completions"
       
    // Create the message array
    let messages = [Message(role: "user", content: prompt)]
    
    // Prepare the request body
    let requestBody = ChatGPTRequest(
        model: "gpt-4o-mini", // or "gpt-3.5-turbo"
        messages: messages,
        max_tokens: 150
    )
    
    // Encode the request body to JSON
    let jsonData = try JSONEncoder().encode(requestBody)
    
    // Create a URL request
    var request = URLRequest(url: URL(string: apiURL)!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(Constants.APIKey)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status Code: \(httpResponse.statusCode)")
    }
//    print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "No response body")")
    
    let decodedResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
    
    if let error = decodedResponse.error {
        throw NSError(domain: "OpenAIAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: error.message])
    }
    
    return decodedResponse.choices.first?.message.content ?? "No response received."
}
