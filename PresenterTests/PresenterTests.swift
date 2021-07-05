//
//  PresenterTests.swift
//  PresenterTests
//
//  Created by Pierre Rougeot on 02/07/2021.
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

class PresenterTests: XCTestCase {

    func testRequestUpdate() {
        let interactor = FizzBuzzInteractorImplementation(statisticsProxy: Constants.statistics) { request in
            let int1: Int? = Constants.request.int1
            let int2: Int? = FizzBuzzInteractorImplementation.processCallIndex > 0 ?  Constants.request.int2 : nil
            let limit: Int? = FizzBuzzInteractorImplementation.processCallIndex > 1 ?  Constants.request.limit : nil
            let str1: String = FizzBuzzInteractorImplementation.processCallIndex > 2 ?  Constants.request.str1 : ""
            let str2: String = FizzBuzzInteractorImplementation.processCallIndex > 3 ?  Constants.request.str2 : ""

            XCTAssertEqual(request, FizzBuzzRequest(int1: int1, int2: int2, limit: limit, str1: str1, str2: str2))

            FizzBuzzInteractorImplementation.processCallIndex += 1
            return Constants.result
        }

        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: interactor)

        executeRequestUpdates(on: presenter)
    }

    func testViewContract() {
        let interactor = FizzBuzzInteractorImplementation(statisticsProxy: Constants.statistics) { _ in
            Constants.result
        }

        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: interactor)

        let viewContract = ViewContractImplementation { viewModel in
            let int1: String = Constants.request.int1?.description ?? ""
            let int2: String = ViewContractImplementation.displayCallIndex > 0
                ?  Constants.request.int2?.description ?? ""
                : ""
            let limit: String = ViewContractImplementation.displayCallIndex > 1
                ?  Constants.request.limit?.description ?? ""
                : ""
            let str1: String = ViewContractImplementation.displayCallIndex > 2 ?  Constants.request.str1 : ""
            let str2: String = ViewContractImplementation.displayCallIndex > 3 ?  Constants.request.str2 : ""

            XCTAssertEqual(viewModel.input.int1, int1)
            XCTAssertEqual(viewModel.input.int2, int2)
            XCTAssertEqual(viewModel.input.limit, limit)
            XCTAssertEqual(viewModel.input.str1, str1)
            XCTAssertEqual(viewModel.input.str2, str2)

            ViewContractImplementation.displayCallIndex += 1
        }

        presenter.viewContract = viewContract

        executeRequestUpdates(on: presenter)
    }

    // MARK: - Private

    private func executeRequestUpdates(on presenter: FizzBuzzPresenterImplementation) {
        presenter.requestUpdate(of: .int1, to: String(Constants.request.int1!))
        presenter.requestUpdate(of: .int2, to: String(Constants.request.int2!))
        presenter.requestUpdate(of: .limit, to: String(Constants.request.limit!))
        presenter.requestUpdate(of: .str1, to: Constants.request.str1)
        presenter.requestUpdate(of: .str2, to: Constants.request.str2)
    }

}

private class FizzBuzzInteractorImplementation: FizzBuzzInteractor {

    static var processCallIndex = 0

    init(statisticsProxy: FizzBuzzStatistics?,
         processProxy: @escaping (FizzBuzzRequest) -> FizzBuzzResult) {
        self.statisticsProxy = statisticsProxy
        self.processProxy = processProxy
    }

    func process(request: FizzBuzzRequest) -> FizzBuzzResult { processProxy(request) }

    var statistics: FizzBuzzStatistics? { statisticsProxy }

    // MARK: - Private

    private let statisticsProxy: FizzBuzzStatistics?
    private let processProxy: (FizzBuzzRequest) -> FizzBuzzResult
}

private class ViewContractImplementation: FizzBuzzViewContract {

    static var displayCallIndex = 0

    init(displayProxy: @escaping (FizzBuzzViewModel) -> Void) {
        self.displayProxy = displayProxy
    }

    func display(viewModel: FizzBuzzViewModel) {
        displayProxy(viewModel)
    }

    // MARK: - Private

    private let displayProxy: (FizzBuzzViewModel) -> Void
}
