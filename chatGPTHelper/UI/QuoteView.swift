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
            Button("Add Quote") {
                Task {
                    //Вынести повторку
                    dependencies.interactors.summary.setupText()
                    await dependencies.interactors.quote.didTapGetIllustration()
                }
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(interactor.illustrations, id: \.quote) { illustration in
                        VStack {
                            Text(illustration.quote)
                            
                            if let imageData = try? Data(contentsOf: URL(
                                string: "file://" + illustration.imageURL)!
                            ),
                               let image = Image(data: imageData) {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(20)
                            } else {
                                Text("Image not found")
                                    .foregroundColor(.gray)
                            }
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

extension Image {
    init?(data: Data) {
        guard let cgImage = CGImageSourceCreateWithData(data as CFData, nil)
            .flatMap({ CGImageSourceCreateImageAtIndex($0, 0, nil) }) else {
            return nil
        }
        self.init(decorative: cgImage, scale: 1.0)
    }
}
