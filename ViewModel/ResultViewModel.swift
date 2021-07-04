//
//  ResultViewModel.swift
//  ViewModel
//
//  Created by Pierre Rougeot on 04/07/2021.
//

/// This view model is the configuration of the results
public enum ResultViewModel {
    public struct Values {
        /// Number of relevant indexes, first index being 1
        public let count: Int

        /// Values, relevant for index in 1...count
        public let provider: (Int) -> String?

        public init(count: Int, provider: @escaping (Int) -> String?) {
            self.count = count
            self.provider = provider
        }
    }

    case irrelevant
    case values(Values)
}
