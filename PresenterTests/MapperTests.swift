//
//  MapperTests.swift
//  PresenterTests
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import XCTest
@testable import Presenter

import Entity
import ViewModel

private enum Constants {
    static let request = FizzBuzzRequest(int1: 3, int2: 2, limit: 6, str1: "R", str2: "test")
    static let result = FizzBuzzResult(count: 5) { value in String(value + value) }
    static let statistics = FizzBuzzStatistics(
        mostUsedRequest: request,
        mostUsedRequestCount: 5,
        totalRequestsCount: 32,
        mostUsedRequestRate: 5/32
    )
}

class MapperTests: XCTestCase {

    func testEmptyRequestAndResult() {
        let viewModel = mapper.map(request: .empty, result: .empty, statistics: nil)

        XCTAssertEqual(viewModel.input.int1, "")
        XCTAssertEqual(viewModel.input.int2, "")
        XCTAssertEqual(viewModel.input.str1, "")
        XCTAssertEqual(viewModel.input.str2, "")
        XCTAssertEqual(viewModel.input.limit, "")

        switch (viewModel.result, viewModel.statistics) {
        case (.irrelevant, .irrelevant):
            break
        default:
            XCTFail()
        }
    }

    func testRequest2AndResult() {
        let viewModel = mapper.map(
            request: Constants.request,
            result: Constants.result,
            statistics: Constants.statistics
        )

        XCTAssertEqual(viewModel.input.int1, "3")
        XCTAssertEqual(viewModel.input.int2, "2")
        XCTAssertEqual(viewModel.input.str1, "R")
        XCTAssertEqual(viewModel.input.str2, "test")
        XCTAssertEqual(viewModel.input.limit, "6")

        switch viewModel.result {
        case .irrelevant:
            XCTFail()
        case let .values(values):
            XCTAssertEqual(values.count, 5)
            XCTAssertEqual(values.provider(1), "2")
            XCTAssertEqual(values.provider(2), "4")
            XCTAssertEqual(values.provider(3), "6")
            XCTAssertEqual(values.provider(4), "8")
            XCTAssertEqual(values.provider(5), "10")
        }

        switch viewModel.statistics {
        case .irrelevant:
            XCTFail()
        case let .data(data):
            XCTAssertEqual(data.parameters.int1, "3")
            XCTAssertEqual(data.parameters.int2, "2")
            XCTAssertEqual(data.parameters.str1, "R")
            XCTAssertEqual(data.parameters.str2, "test")
            XCTAssertEqual(data.parameters.limit, "6")
            XCTAssertEqual(data.ratioDegrees, 5.0 / 32.0 * 360.0)
            XCTAssertEqual(data.description, "15 % (5 / 32)")
        }
    }

    // MARK: - Private

    private let mapper = FizzBuzzViewModelMapper()
}
