//
//  FizzBuzzStatistics.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// Statistics
public struct FizzBuzzStatistics {
    public var mostUsedRequest: FizzBuzzRequest
    public var mostUsedRequestCount: Int
    public var totalRequestsCount: Int
    public var mostUsedRequestRate: Double

    public init(mostUsedRequest: FizzBuzzRequest,
                mostUsedRequestCount: Int,
                totalRequestsCount: Int,
                mostUsedRequestRate: Double) {
        self.mostUsedRequest = mostUsedRequest
        self.mostUsedRequestCount = mostUsedRequestCount
        self.totalRequestsCount = totalRequestsCount
        self.mostUsedRequestRate = mostUsedRequestRate
    }

    /// statistics are relevant if and only if the mostUsedRequest is valid (if there is a most usedRequest
    public var isRelevant: Bool { mostUsedRequest.isValid }
}
