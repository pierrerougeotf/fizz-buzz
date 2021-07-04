//
//  FizzBuzzViewModelMapper.swift
//  Presenter
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Entity
import ViewModel

struct FizzBuzzViewModelMapper {
    func map(request: FizzBuzzRequest, result: FizzBuzzResult, statistics: FizzBuzzStatistics?) -> FizzBuzzViewModel {
        FizzBuzzViewModel(
            input: request.viewModel,
            result: result.viewModel,
            statistics: statistics?.viewModel ?? .irrelevant
        )
    }
}

private extension FizzBuzzRequest {
    var viewModel: ParametersViewModel {
        ParametersViewModel(
            int1: int1.descriptionIfValidAnd(in: 1...Int.max, otherwise: ""),
            int2: int2.descriptionIfValidAnd(in: 1...Int.max, otherwise: ""),
            limit: limit.descriptionIfValidAnd(in: 1...Int.max - 1, otherwise: ""),
            str1: str1,
            str2: str2
        )
    }
}

private extension Optional where Wrapped == Int {
    /// considered invalid if nil or if unwrapped value is out of given range
    /// - Parameters:
    ///   - range: in wich the unwrapped value is considered valid
    ///   - fallback: fallback description string being returned if invalid
    /// - Returns:a formatted description string of the valid int, otherwise fallback
    func descriptionIfValidAnd(in range: ClosedRange<Int>, otherwise fallback: String) -> String {
        guard
            let unwrappedInt = self,
            range.contains(unwrappedInt) else { return "" }
        return unwrappedInt.description
    }
}

private extension FizzBuzzResult {
    var viewModel: ResultViewModel {
        if isRelevant {
            return .values(ResultViewModel.Values(count: count, provider: provider))
        } else {
            return .irrelevant
        }
    }
}

private extension FizzBuzzStatistics {
    var viewModel: StatisticsViewModel {
        if isRelevant {
            let rate = Double(mostUsedRequestCount) / Double(totalRequestsCount)
            return .data(
                StatisticsViewModel.Data(
                    parameters: mostUsedRequest.viewModel,
                    ratioDegrees: Double(rate) * 360.0,
                    // the description displays the ratio and the percentage
                    description: Int(rate * 100).description + " % (\(mostUsedRequestCount) / \(totalRequestsCount))"
                )
            )
        } else {
            return .irrelevant
        }
    }
}
