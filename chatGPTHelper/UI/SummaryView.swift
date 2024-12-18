//
//  SummaryView.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import SwiftUI
import SwiftData

@Model
final class SummaryData {
    @Attribute(.unique) var id: UUID
    var text: String
    
    init(text: String) {
        self.id = UUID()
        self.text = text
    }
}

struct SummaryView: View {
    
    @Environment(\.injected) private var dependencies: DIContainer
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var promptParamsModel: PromptParamsModel
    @Query private var contextData: [SummaryData]
    
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
        }.onChange(of: promptParamsModel.summaries) { _, newValue in
            guard let summary = newValue.last else { return }
            
            let newData = SummaryData(text: summary)
            modelContext.insert(newData)
            do {
                try modelContext.save()
            } catch {
            }
        }.onAppear() {
            contextData.forEach { data in
                // TODO
                promptParamsModel.summaries.append(data.text)
            }
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
