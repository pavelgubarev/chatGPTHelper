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
    
    @StateObject private var interactor: QuoteInteractor
    
    let columns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    @State private var imageURL: String = ""
    @State private var quote: String = ""
    
    init(interactor: QuoteInteractor) {
        self._interactor = StateObject(wrappedValue: interactor)
    }
    
    var body: some View {
        VStack {
            
            
            Button("Цитата") {
                                
                Task {
                    //Вынести повторку
                    dependencies.interactors.summary.setupText()
                    await dependencies.interactors.quote.didTapGetIllustration()
                }
            }
//                       
//            AsyncImage(url: URL(string: interactor.illustration.imageURL)) { image in
//                image
//                    .resizable()
//                    .frame(width: 800, height: 800)
//            } placeholder: {
//                Color.white
//            }
            .clipShape(.rect(cornerRadius: 25))
            
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(interactor.illustrations, id: \.quote) { illustration in
                                    VStack {
                                        Text(illustration.quote)
                                        Text("file://"+illustration.imageURL)
                                        AsyncImage(
                                            url: URL(string: "file://"+illustration.imageURL),
                                            content: { image in                                                
                                            image
                                                .resizable()
                                                .frame(width: 200, height: 200)
                                        }, placeholder: {
                                            Color.white
                                        })
                                    }
                                }
                            }
                            .padding()
                        }
        }.onAppear {
            interactor.onAppear()
        }
    }
}

#Preview {
    SummaryView()
}
