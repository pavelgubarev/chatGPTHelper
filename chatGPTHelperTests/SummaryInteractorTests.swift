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
        let expectation = XCTestExpectation(description: "promptParamsModel should be updated")
        sut.configure(promptParamsModel: PromptParamsModel())
        
        (sut as! SummaryInteractor).promptParamsModel?.$summaries
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
        XCTAssertEqual(sut.promptParamsModel?.summaries.count, 1)
    }
    
    @MainActor func test_fetchSummaries() {        
        // Arrange
        sut.promptParamsModel = PromptParamsModel()
        sut.promptParamsModel?.chapters = ["first", "second"]
        
        let expectation = XCTestExpectation(description: "promptParamsModel should be updated")
        (sut as! SummaryInteractor).promptParamsModel?.$summaries
            .dropFirst() // Skip the initial value
            .sink { value in
                if value.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act
        sut.requestAllSummaries()
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.promptParamsModel?.summaries.first!.text, "sample chat response")
        XCTAssertEqual(sut.promptParamsModel?.summaries.last!.text, "sample chat response")
    }
}
