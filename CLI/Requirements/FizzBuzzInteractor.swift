//
//  FizzBuzzInteractor.swift
//  Presenter
//
//  Created by Pierre Rougeot on 02/07/2021.
//

import Entity

public protocol FizzBuzzInteractor {
    /// processes any fizz buzz request and record the operation for statistics
    /// - Parameter request: request
    /// - returns result if request is valid. In case of invalid request, .empty will be sent
    func process(request: FizzBuzzRequest) -> FizzBuzzResult

    /// nil if no statistics can be computed
    var statistics: FizzBuzzStatistics? { get }
}
