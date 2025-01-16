//
//  Helpers.swift
//  chatGPTHelper
//
//  Created by Павел Губарев on 10.01.2025.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
