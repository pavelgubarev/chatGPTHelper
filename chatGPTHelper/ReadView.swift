//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI

struct ReadView: View {
    var body: some View {
        var response: String = ""
        VStack {
            Button("Read this chapter") {
                Task {
                    do {
                        response = try await fetchChatGPTResponse(prompt: "Hello, how are you?")
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            Text(response)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ReadView()
}
