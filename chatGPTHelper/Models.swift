//
//  Models.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 17.12.2024.
//

import Foundation

class PromptParamsModel: ObservableObject {
    @Published var context = ""
    @Published var mockText = ""
    @Published var isMockEnabled = false
}
