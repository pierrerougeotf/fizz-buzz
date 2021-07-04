//
//  StatisticsRepositoryImplementation.swift
//  Repository
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Entity

public class StatisticsRepositoryImplementation {

    public init() { }

    // MARK: - StatisticsRepository

    public func record(request: FizzBuzzRequest) {
        if let requestCount = results[request] {
            results[request] = requestCount + 1
        } else {
            results[request] = 1
        }
    }

    public var mostUsedRequest: FizzBuzzRequest? { mostUsedRequestElement?.key }

    public var mostUsedRequestCount: Int? { mostUsedRequestElement?.value }

    public var totalRequestsCount: Int { results.values.reduce(0) { $0 + $1 } }

    // MARK: - Private

    private var results: [FizzBuzzRequest: Int] = [:]

    private var mostUsedRequestElement: Dictionary<FizzBuzzRequest, Int>.Element? {
        guard
            !results.isEmpty,
            let maxRequestCount = results.values.max(),
            let mostUsedRequestElement = (results.first { $0.value == maxRequestCount }) else { return nil }
        return mostUsedRequestElement
    }
}
