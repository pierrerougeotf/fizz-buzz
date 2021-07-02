//
//  FizzBuzzStatistics.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// Statistics
public struct FizzBuzzStatistics {
    public var mostUsedRequest: FizzBuzzRequest
    /// From 0.0 to 1.0: out of all requests having registered
    public var mostUsedRequestRate: Double

    public init(mostUsedRequest: FizzBuzzRequest, mostUsedRequestRate: Double) {
        self.mostUsedRequest = mostUsedRequest
        self.mostUsedRequestRate = mostUsedRequestRate
    }
}
