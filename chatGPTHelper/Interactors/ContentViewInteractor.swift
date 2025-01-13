//
//  ContextViewInteractor.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 27.12.2024.
//

import Foundation
import SwiftData
import SwiftUI

final class ContentViewInteractor: Interactor {

    @MainActor
    func onAppear() {
        if let data: [ContextData] = localRepository.fetch() {
            if let context = data.first {
                promptParamsModel?.context = context.text
            }
        }
    }
}
