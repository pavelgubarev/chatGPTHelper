//
//  IllustrationDetailViewInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation
import SwiftData

class IllustrationDetailViewInteractor: Interactor {
    
    func getInfoForIllustration(id: PersistentIdentifier) -> Illustration? {
        guard let result: IllustrationContainer = localRepository.fetch(withID: id) else { return nil }        
        return result.asIllustration()
    }
}
