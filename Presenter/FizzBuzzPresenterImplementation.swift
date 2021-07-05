//
//  FizzBuzzPresenterImplementation.swift
//  Presenter
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Entity
import ViewModel

public class FizzBuzzPresenterImplementation {
    public init(fizzBuzzInteractor: FizzBuzzInteractor) {
        self.fizzBuzzInteractor = fizzBuzzInteractor
    }

    public var viewContract: FizzBuzzViewContract?

    // MARK: - FizzBuzzPresenter

    public func start() {
        updateUI(for: self.request)
    }

    public func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String) {
        // create new request with udpated parameter
        let updatedRequest = request.update(parameter, with: newValue)

        // Update stored request only if updated request is valid
        self.request = updatedRequest ?? self.request

        updateUI(for: self.request)
    }

    // MARK: - Private

    private var request = FizzBuzzRequest.empty
    private let mapper = FizzBuzzViewModelMapper()
    private let fizzBuzzInteractor: FizzBuzzInteractor

    private func updateUI(for request: FizzBuzzRequest) {
        let result = fizzBuzzInteractor.process(request: request)
        let statistics = fizzBuzzInteractor.statistics
        let viewModel = mapper.map(request: request, result: result, statistics: statistics)
        viewContract?.display(viewModel: viewModel)
    }
}

private extension FizzBuzzRequest {
    /// Create a new request from exsiting one, modifying parameter
    /// - Parameters:
    ///   - parameter: modified parameter
    ///   - stringValue: value of modified parameter as string
    /// - Returns: returns update request, or nil if parameter value is invalid
    func update(_ parameter: FizzBuzzParameter,
                with stringValue: String) -> FizzBuzzRequest? {
        var updatedRequest = self
        switch parameter {
        case .int1, .int2, .limit:
            guard
                let intValue = stringValue.toIntReplacingEmptyWithZero,
                let keyPath = parameter.intKeyPath else { return nil }
            updatedRequest[keyPath: keyPath] = intValue
        case .str1, .str2:
            guard let keyPath = parameter.stringKeyPath else { return nil }
            updatedRequest[keyPath: keyPath] = stringValue
        }
        return updatedRequest
    }
}

private extension String {
    var toIntReplacingEmptyWithZero: Int? {
        guard isEmpty else { return Int(self) }
        return 0
    }
}

private extension FizzBuzzParameter {
    var intKeyPath: WritableKeyPath<FizzBuzzRequest, Int?>? {
        switch self {
        case .int1:
            return \.int1
        case .int2:
            return \.int2
        case .limit:
            return \.limit
        case .str1, .str2:
            return nil
        }
    }

    var stringKeyPath: WritableKeyPath<FizzBuzzRequest, String>? {
        switch self {
        case .int1, .int2, .limit:
            return nil
        case .str1:
            return \.str1
        case .str2:
            return \.str2
        }
    }

}
