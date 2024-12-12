//
//  Request.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import Foundation

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
}

// Async function to call ChatGPT API
func fetchChatGPTResponse(prompt: String) async throws -> String {
    // Your API URL and Key
    let apiURL = "https://api.openai.com/v1/chat/completions"
    let apiKey = "your-openai-api-key" // Replace with your actual key
    
    // Create the message array
    let messages = [Message(role: "user", content: prompt)]
    
    // Prepare the request body
    let requestBody = ChatGPTRequest(
        model: "gpt-4", // or "gpt-3.5-turbo"
        messages: messages,
        max_tokens: 150
    )
    
    // Encode the request body to JSON
    let jsonData = try JSONEncoder().encode(requestBody)
    
    // Create a URL request
    var request = URLRequest(url: URL(string: apiURL)!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    // Perform the API call
    let (data, _) = try await URLSession.shared.data(for: request)
    
    // Decode the response
    let response = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
    
    // Extract and return the response message content
    return response.choices.first?.message.content ?? "No response received."
}
