//
//  SummaryView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import SwiftUI

struct QuoteView: View {
    @Environment(\.injected) private var dependencies: DIContainer
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    
    let columns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    @State private var imageURL: String = ""

    var body: some View {
        VStack {
            
            
            Button("Цитата") {
                

                Task {
                    //Вынести повторку
                    dependencies.interactors.summary.setupText()
                    imageURL = await dependencies.interactors.quote.requestQuoteAndIllustration()
                }
            }
            
            
            AsyncImage(url: URL(string: imageURL)) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 128, height: 128)
            .clipShape(.rect(cornerRadius: 25))
            
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 20) {
//                    ForEach(promptParamsModel.summaries, id: \.self) { summary in
//                        scrollableTextCard(text: summary.text)
//                    }
//                }
//                .padding()
//            }
        }
    }    
}

#Preview {
    SummaryView()
}
