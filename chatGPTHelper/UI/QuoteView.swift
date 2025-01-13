//
//  SummaryView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import SwiftUI

struct QuoteView: View {
    @EnvironmentObject private var dependencies: DIContainer
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    
    @StateObject private var illustrations = IllustrationsViewModel()
    @Binding var navigationPath: NavigationPath
    
    let columns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    @State private var imageURL: String = ""
    @State private var quote: String = ""
    
    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack {                        
            Button("Add Quote") {
                Task {
                    await dependencies.interactors.quote.didTapGetIllustration()
                }
            }.padding()
           
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(dependencies.interactors.quote.illustrationsViewModel.illustrations, id: \.id) { illustration in
                        IllustrationView(illustration: illustration)
                            .onTapGesture {
                                //TODO
                                navigationPath.append(IllustrationDetailViewData(id: illustration.persistentID!))
                            }
                    }
                }
                .padding()
                .onReceive(dependencies.interactors.quote.illustrationsViewModel.$illustrations) { self.illustrations.illustrations = $0 }
            }
        }.onAppear {
            dependencies.interactors.quote.onAppear()
        }
    }
}

struct IllustrationView: View {
    @ObservedObject var illustration: Illustration
    
    var body: some View {
        VStack {
            Text(illustration.quote)
            
            if illustration.imageURL != "" {
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
            } else {
                Text("...ждём")
            }
        }
    }
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
