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
    
    var body: some View {
        VStack {
            Button("Цитата") {
                
                //Вынести повторку
                dependencies.interactors.summary.setupText()

                dependencies.interactors.quote.requestQuoteAndIllustration()
            }            
            
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
