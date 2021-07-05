//
//  FizzBuzzPresenter.swift
//  View
//
//  Created by Pierre Rougeot on 02/07/2021.
//

public protocol FizzBuzzParameter {
    static var int1: Self { get }
    static var int2: Self { get }
    static var limit: Self { get }
    static var str1: Self { get }
    static var str2: Self { get }

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

