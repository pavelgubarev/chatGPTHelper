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
            
    func set(appStateModel: AppStateModel) {
        [
            self.interactors.summary,
            self.interactors.quote,
            self.interactors.contentView,
            self.interactors.illDetail,
            self.interactors.settings 
        ].forEach { $0.configure(appStateModel: appStateModel) }

        self.webRepository.configure(appStateModel: appStateModel)
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
            illDetail: makeInteractor(IllustrationDetailViewInteractor.self),
            settings: makeInteractor(SettingsInteractor.self)
        )
    }
}

struct Interactors {
    let summary: SummaryInteractorProtocol
    let quote: QuoteInteractorProtocol
    let contentView: ContentViewInteractor
    let illDetail: IllustrationDetailViewInteractorProtocol
    let settings: SettingsInteractorProtocol 
}
