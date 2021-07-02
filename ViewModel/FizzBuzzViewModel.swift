//
//  FizzBuzzViewModel.swift
//  ViewModel
//
//  Created by Pierre Rougeot on 02/07/2021.
//

import Combine

public class FizzBuzzViewModel: ObservableObject {

    /// Fizz Buzz parameters as strings
    public struct Parameters {
        public var int1: String
        public var int2: String
        public var limit: String
        public var str1: String
        public var str2: String

        public init(int1: String,
                    int2: String,
                    limit: String,
                    str1: String,
                    str2: String) {
            self.int1 = int1
            self.int2 = int2
            self.limit = limit
            self.str1 = str1
            self.str2 = str2
        }

        public static let `default` = Parameters(int1: "", int2: "", limit: "", str1: "", str2: "")
    }

    /// Result, similar to an array of values
    public struct Result {
        /// array size
        public let count: Int

        /// array values
        public let provider: (Int) -> String?

        public init(count: Int,
                    provider: @escaping (Int) -> String?) {
            self.count = count
            self.provider = provider
        }

        public static let `default` = Result(count: 1) { _ in ""}
    }

    public struct Statistics {
        /// Most used request parameters
        public var parameters: Parameters

        /// Most used request frequancy rate
        public var rate: Double

        public init(parameters: Parameters,
                    rate: Double) {
            self.parameters = parameters
            self.rate = rate
        }

        public static let `default` = Statistics(parameters: Parameters.default, rate: 0.0)
    }

    /// Input parameters
    @Published public var input: Parameters

    /// Fizz buzz result for input parameters
    @Published public var result: Result

    /// statistics for most used request
    @Published public var statistics: Statistics?

    public static let `default` = FizzBuzzViewModel(input: .default, result: .default, statistics: nil)

    public init(input: Parameters,
                result: Result,
                statistics: Statistics?) {
        self.input = input
        self.result = result
        self.statistics = statistics
    }
}
