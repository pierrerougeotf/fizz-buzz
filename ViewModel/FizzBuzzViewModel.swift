//
//  FizzBuzzViewModel.swift
//  ViewModel
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// This view model embed all the Fizz Buzz screen sections
public struct FizzBuzzViewModel {
    public let input: ParametersViewModel
    public let result: ResultViewModel
    public let statistics: StatisticsViewModel

    public init(input: ParametersViewModel, result: ResultViewModel, statistics: StatisticsViewModel) {
        self.input = input
        self.result = result
        self.statistics = statistics
    }

    public static let empty = Self(input: .empty, result: .irrelevant, statistics: .irrelevant)
}
