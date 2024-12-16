//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI

struct ReadView: View {
    @State var response: String = "not yet"
    var body: some View {
        VStack {
            Button("Read this chapter") {
                Task {
                 await sendRequest()
                }
            }
            Text(response)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func sendRequest() async  {
        let task = Task.detached {
            do {
                let result = try await fetchChatGPTResponse(prompt: "Hello, how are you?")
                return result
            } catch {
                print("Error: \(error.localizedDescription)")
                return ""
            }
        }
        response = await task.value
    }
}

#Preview {
    ReadView()
}
