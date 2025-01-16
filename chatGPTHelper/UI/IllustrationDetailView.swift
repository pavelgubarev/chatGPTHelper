//
//  IllustrationDetailView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import SwiftUI

struct IllustrationDetailView: View {
    let data: IllustrationDetailViewData
    @State var illustration: Illustration?
    @EnvironmentObject private var dependencies: DIContainer

    var body: some View {
//        guard let illustration else { return Text("fail") }
        
        ScrollView {
            
            VStack {
                Text(illustration?.quote ?? "")
                    .padding()

                Text(illustration?.prompt ?? "")
                    .padding()

                if let url = illustration?.imageURL  {
                    // TODO (!)
                    if let imageData = try? Data(contentsOf: URL(
                        string: "file://" + url)!
                    ),
                       let image = Image(data: imageData) {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .padding()
                        
                    } else {
                        Text("Image not found")
                            .foregroundColor(.gray)
                    }
                } else {
                    Text("...ждём")
                }
            }
        }.onAppear {
           illustration = dependencies.interactors.illDetail.getInfoForIllustration(id: data.id)
        }
    }
}
