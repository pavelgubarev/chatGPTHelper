//
//  LocalRepositoryMock.swift
//  chatGPTHelperTests
//
//  Created by Павел Губарев on 10.01.2025.
//

import Foundation
import SwiftData
@testable import chatGPTHelper

final class LocalRepositoryMock: LocalRepositoryProtocol {
    
    private(set) var isFetchCalled = false
    private(set) var isFetchWithIDCalled = false
    private(set) var isDeleteAllSummariesCalled = false
    private(set) var isSaveCalled = false
    private(set) var isDownloadAndSaveImageCalled = false

    func fetch<T>() -> [T]? where T: PersistentModel {
        isFetchCalled = true
        if T.self == SummaryData.self {
            return [SummaryData(chapterNumber: 1, text: "Dummy text") as! T]
        }
        return nil
    }
    
    func fetch<T>(withID id: PersistentIdentifier) -> T? where T: PersistentModel {
        isFetchWithIDCalled = true
        return nil
    }
    
    func deleteAllSummaries() {
        isDeleteAllSummariesCalled = true
    }
    
    func save<T>(_ object: T) where T: PersistentModel {
        isSaveCalled = true
    }
    
    func downloadAndSaveImage(from url: String, completion: @escaping (String?) -> Void) {
        isDownloadAndSaveImageCalled = true
    }
}
