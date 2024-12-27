//
//  Assembly.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 18.12.2024.
//

import Foundation
import SwiftUI

@MainActor
struct DIContainer: EnvironmentKey {
    //TODO
    static var defaultValue: Self { Self.default }
    private static let `default` = Self()
    
    let interactors: Interactors
    let webRepository: WebRepository
    let localRepository: LocalRepository
        
    init() {
        self.webRepository = WebRepository()
        self.localRepository = LocalRepository()
        
        self.interactors = .init(
            summary: SummaryInteractor(
                webRepository: self.webRepository,
                localRepository: self.localRepository
            ),
            quote: QuoteInteractor(
                webRepository: self.webRepository,
                localRepository: self.localRepository
            ),
            contentView: ContentViewInteractor(
                webRepository: self.webRepository,
                localRepository: self.localRepository
            )
        )
    }
  
    func set(promptParamsModel: PromptParamsModel) {
        self.interactors.summary.configure(promptParamsModel: promptParamsModel)
        self.interactors.quote.configure(promptParamsModel: promptParamsModel)
        self.interactors.contentView.configure(promptParamsModel: promptParamsModel)
        self.webRepository.configure(promptParamsModel: promptParamsModel)
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

struct Interactors {
    let summary: SummaryInteractor
    let quote: QuoteInteractor
    let contentView: ContentViewInteractor
}

extension View {
    func inject(_ container: DIContainer) -> some View {
        return self
            .environment(\.injected, container)
    }
}
