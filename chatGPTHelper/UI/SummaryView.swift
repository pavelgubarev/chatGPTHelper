//
//  SummaryView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contextData: [SummaryData]

    @Environment(\.injected) private var dependencies: DIContainer
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    
    let columns = [
        GridItem(.adaptive(minimum: 300))
    ]
    
    var body: some View {
        VStack {
            Button("Get All The Summaries") {
                dependencies.interactors.summary.setupText()
                dependencies.interactors.summary.requestAllSummaries()
            }.padding()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(promptParamsModel.summaries, id: \.self) { summary in
                        scrollableTextCard(text: summary)
                    }
                }
                .padding()
            }
        }
        .onAppear() {
            print(self.contextData)
        }
    }
    
    private func scrollableTextCard(text: String) -> some View {
        return ScrollView(showsIndicators: false) {
            Text(text)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 200)
        .background(Color.blue.opacity(0.3))
        .padding(12)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SummaryView()
}
