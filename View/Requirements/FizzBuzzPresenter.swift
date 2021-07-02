//
//  FizzBuzzPresenter.swift
//  View
//
//  Created by Pierre Rougeot on 02/07/2021.
//

public enum FizzBuzzParameter {
    case int1
    case int2
    case limit
    case str1
    case str2
}

public protocol FizzBuzzPresenter {
    /// Asks the presenter to go to init state
    func start()

    /// A FizzBuzz input parameter has changed, asks for and update
    /// - Parameters:
    ///   - parameter: the parameter having changed
    ///   - newValue: the value of the parameter being captured
    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String)
}

