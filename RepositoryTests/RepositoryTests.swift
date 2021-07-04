//
//  RepositoryTests.swift
//  RepositoryTests
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import XCTest
@testable import Repository

import Entity

private enum Constants {
    static let request1 = FizzBuzzRequest(int1: 1, int2: 2, limit: 5, str1: "", str2: "test")
    static let request2 = FizzBuzzRequest(int1: 3, int2: 2, limit: 5, str1: "", str2: "test")
    static let request3 = FizzBuzzRequest(int1: 1, int2: 4, limit: 5, str1: "test", str2: "test")
    static let request4 = request3
}

class RepositoryTests: XCTestCase {
    func testEmptyRecords() throws {
        let repository = StatisticsRepositoryImplementation()

        XCTAssertNil(repository.mostUsedRequest)
        XCTAssertNil(repository.mostUsedRequestCount)
        XCTAssertEqual(repository.totalRequestsCount, 0)
    }

    func testSomeRecords() throws {
        let repository = StatisticsRepositoryImplementation()

        repository.record(request: Constants.request1)
        repository.record(request: Constants.request2)
        repository.record(request: Constants.request2)
        repository.record(request: Constants.request3)
        repository.record(request: Constants.request4)
        repository.record(request: Constants.request4)


        XCTAssertEqual(repository.mostUsedRequest, Constants.request3) // request3 and request4 are identical
        XCTAssertEqual(repository.mostUsedRequestCount, 3)
        XCTAssertEqual(repository.totalRequestsCount, 6)
    }
}
