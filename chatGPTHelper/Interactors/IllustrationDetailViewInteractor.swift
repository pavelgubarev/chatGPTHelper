//
//  IllustrationDetailViewInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation
import SwiftData

protocol IllustrationDetailViewInteractorProtocol: Interactor {
    func getInfoForIllustration(id: PersistentIdentifier) -> Illustration?
    func delete(id: PersistentIdentifier)
}

class IllustrationDetailViewInteractor: Interactor, IllustrationDetailViewInteractorProtocol {
    
    func getInfoForIllustration(id: PersistentIdentifier) -> Illustration? {
        guard let result: IllustrationContainer = localRepository.fetch(withID: id) else { return nil }        
        return result.asIllustration()
    }
    
    @MainActor
    func delete(id: PersistentIdentifier) {
        localRepository.delete(withID: id)
        appStateModel?.isQuoteLocalCacheValid = false
        appStateModel?.objectWillChange.send()
    }
}
