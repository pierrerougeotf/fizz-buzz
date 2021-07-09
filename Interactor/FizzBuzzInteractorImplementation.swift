//
//  FizzBuzzInteractorImplementation.swift
//  Interactor
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Entity

public class FizzBuzzInteractorImplementation {
    public init(statisticsRepository: StatisticsRepository) {
        self.statisticsRepository = statisticsRepository
    }

    // MARK: - FizzBuzzInteractor

    public func process(request: FizzBuzzRequest) -> FizzBuzzResult {
        guard request.isValid,
              let int1 = request.int1,
              let int2 = request.int2,
              let limit = request.limit else { return .empty }
        statisticsRepository.record(request: request)
        return FizzBuzzResult(count: limit) { index in
            guard (1...limit).contains(index) else { return nil }
            switch (index % int1 == 0, index % int2 == 0) {
            case (true, false):
                return request.str1
            case (false, true):
                return request.str2
            case (true, true):
                return request.str1 + request.str2
            case (false, false):
                return String(index)
            }
        }
    }

    public var statistics: FizzBuzzStatistics? {
        guard
            let mostUsedRequest = statisticsRepository.mostUsedRequest,
            let mostUsedRequestCount = statisticsRepository.mostUsedRequestCount,
            statisticsRepository.totalRequestsCount > 0 else { return nil }
        return FizzBuzzStatistics(
            mostUsedRequest: mostUsedRequest,
            mostUsedRequestCount: mostUsedRequestCount,
            totalRequestsCount: statisticsRepository.totalRequestsCount,
            mostUsedRequestRate: Double(mostUsedRequestCount) / Double(statisticsRepository.totalRequestsCount)
        )
    }

    // MARK: - Private

    private let statisticsRepository: StatisticsRepository
}
