//
//  InteractorTests.swift
//  InteractorTests
//
//  Created by Pierre Rougeot on 02/07/2021.
//

import XCTest
@testable import Interactor

import Entity

private enum Constants {
    static let request1 = FizzBuzzRequest(int1: 1, int2: 2, limit: 5, str1: "", str2: "test")
    static let request2 = FizzBuzzRequest(int1: 3, int2: 2, limit: 6, str1: "R", str2: "test")
    static let request3 = FizzBuzzRequest(int1: 1, int2: 4, limit: 5, str1: "test", str2: "test")
    static let request4 = request3
}

class InteractorTests: XCTestCase {

    func testEmptyStatistics() {
        let repository = StatisticsRepositoryImplementationEmpty()
        let interactor = FizzBuzzInteractorImplementation(statisticsRepository: repository)

        XCTAssertNil(interactor.statistics)
    }

    func testNonEmptyStatistics() {
        let repository = StatisticsRepositoryImplementationNonEmpty()
        let interactor = FizzBuzzInteractorImplementation(statisticsRepository: repository)

        XCTAssertEqual(interactor.statistics?.mostUsedRequest, Constants.request4)
        XCTAssertEqual(interactor.statistics?.mostUsedRequestCount, 3)
        XCTAssertEqual(interactor.statistics?.totalRequestsCount, 6)
        XCTAssertEqual(interactor.statistics?.mostUsedRequestRate, 0.5)
    }

    func testNonEmptyResult() {
        let repository = StatisticsRepositoryImplementationNonEmpty()
        let interactor = FizzBuzzInteractorImplementation(statisticsRepository: repository)

        let result = interactor.process(request: Constants.request2)

        XCTAssertEqual(result.count, 7)
        XCTAssertEqual(result.provider(1), "1")
        XCTAssertEqual(result.provider(2), "test")
        XCTAssertEqual(result.provider(3), "R")
        XCTAssertEqual(result.provider(4), "test")
        XCTAssertEqual(result.provider(5), "5")
        XCTAssertEqual(result.provider(6), "Rtest")
    }
}

private class StatisticsRepositoryImplementationEmpty: StatisticsRepository {
    func record(request: FizzBuzzRequest) { }

    var mostUsedRequest: FizzBuzzRequest? { nil }
    var mostUsedRequestCount: Int? { nil }
    var totalRequestsCount: Int { 0 }
}

private class StatisticsRepositoryImplementationNonEmpty: StatisticsRepository {
    func record(request: FizzBuzzRequest) { }

    var mostUsedRequest: FizzBuzzRequest? { Constants.request4 }
    var mostUsedRequestCount: Int? { 3 }
    var totalRequestsCount: Int { 6 }
}

