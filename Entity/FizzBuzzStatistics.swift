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

    /// statistics are relevant if and only if the mostUsedRequest is valid (if there is a most usedRequest
    public var isRelevant: Bool { mostUsedRequest.isValid }
}
