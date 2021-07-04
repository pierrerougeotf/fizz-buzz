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
    /// - returns result
    func process(request: FizzBuzzRequest) -> FizzBuzzResult
    
    var statistics: FizzBuzzStatistics? { get }
}
