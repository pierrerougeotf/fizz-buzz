//
//  StatisticsRepository.swift
//  Interactor
//
//  Created by Pierre Rougeot on 02/07/2021.
//

import Entity

public protocol StatisticsRepository {
    func record(request: FizzBuzzRequest)
    var mostUsedRequest: FizzBuzzRequest? { get }
    var mostUsedRequestCount: Int? { get }
    var totalRequestsCount: Int { get }
}
