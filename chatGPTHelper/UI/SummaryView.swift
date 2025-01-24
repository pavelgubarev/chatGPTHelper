//
//  SummaryView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import SwiftUI

struct SummaryView: View {
    @EnvironmentObject private var dependencies: DIContainer
    @EnvironmentObject private var appStateModel: AppStateModel
    
    let columns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        VStack {
            Button("Update All The Summaries") {
                // TODO: refactor this
                dependencies.interactors.summary.setupText()
                dependencies.interactors.summary.requestAllSummaries()
            }.padding()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(appStateModel.summaries, id: \.self) { summary in
                        scrollableTextCard(text: summary.text)
                    }
                }
                .padding()
            }
        }
        .onAppear() {
            dependencies.interactors.summary.onAppear()
        }
    }
    
    private func scrollableTextCard(text: String) -> some View {
        ZStack {
            Color.blue.opacity(0.3)
                .cornerRadius(10)
            ScrollView(showsIndicators: false) {
                Text(text)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 200)
            .padding(12)
        }
    }
}

#Preview {
    SummaryView()
}
