//
//  FizzBuzzViewContract.swift
//  Presenter
//
//  Created by Pierre Rougeot on 04/07/2021.
//

import ViewModel

public protocol FizzBuzzViewContract {
    /// Configure the main screen
    /// - Parameter viewModel: fizz buzz view model containing all Fizz Buzz view configuration
    func display(viewModel: FizzBuzzViewModel)
}
