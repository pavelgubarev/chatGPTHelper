//
//  SummaryInteractorTests.swift
//  chatGPTHelperTests
//
//  Created by Павел Губарев on 10.01.2025.
//

import XCTest
import Combine
@testable import chatGPTHelper

final class SummaryInteractorTests: XCTestCase {
    
    var sut: SummaryInteractorProtocol!
    let webRepositoryMock = WebRepositoryMock()
    let localRepositoryMock = LocalRepositoryMock()
    var cancellables: Set<AnyCancellable>!
        
    override func setUp() {
        sut = SummaryInteractor(webRepository: webRepositoryMock, localRepository: localRepositoryMock)
        cancellables = []
    }
    
    @MainActor func test_onAppear() {
        // Arrange
        let expectation = XCTestExpectation(description: "appStateModel should be updated")
        sut.configure(appStateModel: AppStateModel())
        
        (sut as! SummaryInteractor).appStateModel?.$summaries
            .dropFirst()
            .sink { value in
                XCTAssertNotNil(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Act
        sut.onAppear()
        
        // Assert
        XCTAssertTrue(localRepositoryMock.isFetchCalled)
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.appStateModel?.summaries.count, 1)
    }
    
    @MainActor func test_fetchSummaries() {        
        // Arrange
        sut.appStateModel = AppStateModel()
        sut.appStateModel?.chapters = ["first", "second"]
        
        let expectation = XCTestExpectation(description: "appStateModel should be updated")
        (sut as! SummaryInteractor).appStateModel?.$summaries
            .dropFirst() 
            .sink { value in
                if value.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        sut.requestAllSummaries()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.appStateModel?.summaries.first!.text, "sample chat response")
        XCTAssertEqual(sut.appStateModel?.summaries.last!.text, "sample chat response")
        XCTAssertTrue(localRepositoryMock.isSaveCalled)
    }
}
