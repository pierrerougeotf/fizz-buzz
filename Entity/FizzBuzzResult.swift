//
//  FizzBuzzResult.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// The representation of the result is similar to an array.
/// Not knowing how the compiler will implement it, the choice of this representation is made to ensure memory peformance
public struct FizzBuzzResult {
    /// Number of relevant indexes, first index being 1
    public let count: Int

    /// Values, relevant for index in 1...count
    public let provider: (Int) -> String?

    public init(count: Int, provider: @escaping (Int) -> String?) {
        self.count = count
        self.provider = provider
    }

    public static let empty = FizzBuzzResult(count: 0, provider: { _ in nil } )

    /// A result will be irrelevant if it cannot return any value
    public var isRelevant: Bool { count > 0 }
}
