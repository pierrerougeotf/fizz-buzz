//
//  FizzBuzzResult.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// The representation of the result is similar to an array.
/// Not knowing how the compiler will implement it, the choice of this representation is made to ensure memory peformance
public struct FizzBuzzResult {
    public let count: Int
    public let valuesProvider: (Int) -> String?

    public init(count: Int, valuesProvider: @escaping (Int) -> String?) {
        self.count = count
        self.valuesProvider = valuesProvider
    }
}
