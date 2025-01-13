//
//  Assembly.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 18.12.2024.
//

import Foundation
import SwiftUI

class DIContainer: ObservableObject {
    
    let interactors: Interactors
    let webRepository: WebRepository
    let localRepository: LocalRepository
    
    init(interactors: Interactors, webRepository: WebRepository, localRepository: LocalRepository) {
        self.interactors = interactors
        self.webRepository = webRepository
        self.localRepository = localRepository
    }
        
    
    //TODO: Move
    func set(promptParamsModel: PromptParamsModel) {
        self.interactors.summary.configure(promptParamsModel: promptParamsModel)
        self.interactors.quote.configure(promptParamsModel: promptParamsModel)
        self.interactors.contentView.configure(promptParamsModel: promptParamsModel)
        self.webRepository.configure(promptParamsModel: promptParamsModel)
    }
}

final class Assembly {
    let webRepository: WebRepository
    let localRepository: LocalRepository
    
    init() {
        self.webRepository = WebRepository()
        self.localRepository = LocalRepository()
    }
    
    func makeInteractor<T: Interactor>(_ subclass: T.Type ) -> T {
        return T(webRepository: webRepository, localRepository: localRepository)
    }
    
    func makeAllInteractors() -> Interactors {
        .init(
            summary: makeInteractor(SummaryInteractor.self),
            quote: makeInteractor(QuoteInteractor.self),
            contentView: makeInteractor(ContentViewInteractor.self),
            illDetail: makeInteractor(IllustrationDetailViewInteractor.self)
        )
    }
}

struct Interactors {
    let summary: SummaryInteractorProtocol
    let quote: QuoteInteractor
    let contentView: ContentViewInteractor
    let illDetail: IllustrationDetailViewInteractor
}
