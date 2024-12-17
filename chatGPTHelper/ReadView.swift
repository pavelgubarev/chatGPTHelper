//
//  ReadView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 12.12.2024.
//

import SwiftUI

struct ReadView: View {
    @State var response: String = "not yet"
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    let interactor = Interactor()
    
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
//        interactor.prepare()
//        guard let request = interactor.buildRequest(promptParamsModel) else { return }
//                        
//        let task = Task.detached {
//            do {
//                let result = try await fetchChatGPTResponse(prompt: request)
//                return result
//            } catch {
//                print("Error: \(error.localizedDescription)")
//                return ""
//            }
//        }
//        response = await task.value
    }
}

#Preview {
    ReadView()
}
