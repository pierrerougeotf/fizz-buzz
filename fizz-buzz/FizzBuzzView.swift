//
//  FizzBuzzView.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 28/06/2021.
//

import SwiftUI

private enum Constants {
    static let title = "Fizz Buzz"
    static let int1Label = "Int1"
    static let int2Label = "Int2"
    static let limitLabel = "Limit"
    static let str1Label = "Str1"
    static let str2Label = "Str2"
    static let firstColor = Color.blue
    static let secondColor = Color.red
    static let accentColor = Color.orange
}

public enum FizzBuzzParameter {
    case int1
    case int2
    case limit
    case str1
    case str2
}

extension FizzBuzzParameter {
    func value(for viewModel: FizzBuzzViewModel) -> String {
        switch self {
        case .int1:
            return viewModel.inputParameters.int1
        case .int2:
            return viewModel.inputParameters.int2
        case .limit:
            return viewModel.inputParameters.limit
        case .str1:
            return viewModel.inputParameters.str1
        case .str2:
            return viewModel.inputParameters.str2
        }
    }
}

public protocol FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel)
}

public protocol FizzBuzzPresenter {
    func start()
    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String)
}

public class FizzBuzzViewModel: ObservableObject {

    public struct Parameters {
        public var int1: String
        public var int2: String
        public var limit: String
        public var str1: String
        public var str2: String

        public static let `default` = Parameters(int1: "", int2: "", limit: "", str1: "", str2: "")
    }

    public struct Values {
        public let count: Int
        public let provider: (Int) -> String?

        public static let `default` = Values(count: 1) { _ in ""}
    }

    public struct Result {
        public var parameters: Parameters
        public var ratio: CGFloat

        static let `default` = Result(parameters: Parameters.default, ratio:     0.0)
    }

    @Published public var inputParameters: Parameters
    @Published public var values: Values
    @Published public var result: Result?

    static let `default` = FizzBuzzViewModel(inputParameters: .default, values: .default, result: .default)

    public init(inputParameters: Parameters,
                values: Values,
                result: Result?) {
        self.inputParameters = inputParameters
        self.values = values
        self.result = result
    }
}

extension FizzBuzzViewModel.Values: RandomAccessCollection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return count }
    public subscript(_ index: Int) -> (id: Int, value: String) { (id: index, value: provider(index) ?? "") }
}

struct FizzBuzzView: View {

    private var presenter: FizzBuzzPresenter?

    @ObservedObject var viewModel: FizzBuzzViewModel

    public init(presenter: FizzBuzzPresenter?, viewModel: FizzBuzzViewModel) {
        self.presenter = presenter
        self.viewModel = viewModel
    }

    var int1Proxy: Binding<String> { binding(for: .int1, of: viewModel) }
    var int2Proxy: Binding<String> { binding(for: .int2, of: viewModel) }
    var limitProxy: Binding<String> { binding(for: .limit, of: viewModel) }
    var str1Proxy: Binding<String> { binding(for: .str1, of: viewModel) }
    var str2Proxy: Binding<String> { binding(for: .str2, of: viewModel) }

    func binding(for parameter: FizzBuzzParameter, of viewModel: FizzBuzzViewModel) -> Binding<String> {
        Binding<String> {
            parameter.value(for: viewModel)
        } set: {
            presenter?.requestUpdate(of: parameter, to: $0)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Input")) {
                    InputView(color: Constants.firstColor, label: Constants.int1Label, valueProxy: int1Proxy)
                    InputView(color: Constants.secondColor, label: Constants.int2Label, valueProxy: int2Proxy)
                    InputView(color: Constants.firstColor, label: Constants.str1Label, valueProxy: str1Proxy)
                    InputView(color: Constants.secondColor, label: Constants.str2Label, valueProxy: str2Proxy)
                    InputView(color: Constants.accentColor, label: Constants.limitLabel, valueProxy: limitProxy)
                }

                Section(header: Text("Result")) {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<viewModel.values.count, id: \.self) { index in
                                if let value = viewModel.values.provider(index) {
                                    VStack {
                                        Text(String(index))
                                        Text(value)
                                    }
                                }
                            }
                        }
                    }
                }

                Section(header: Text("Statistics")) {
                    HStack {
                        Text("\r- Int1: 310\r- Int2: sdfsdfqsdfqsdfqsdfqsdfqsdfqsdfqsdf\r- Int3Int1: 310\r- Int2: sdfsdf\r- Limit: 100")
                        VStack {
                            Pie(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: 145))
                            Text("38%")
                        }
                    }
                }
            }
            .navigationBarTitle(Constants.title)
        }
    }
}

struct InputView: View {
    let color: Color
    let label: String
    let valueProxy: Binding<String>

    var body: some View {
        HStack {
            ZStack {
                color
                    .ignoresSafeArea()
                Text(label)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }.layoutPriority(0)
            Spacer()
            TextField(label, text: valueProxy)
                .multilineTextAlignment(.leading)
                .foregroundColor(color)
        }
    }
}

public struct FizzBuzzRequest {
    public var int1: Int
    public var int2: Int
    public var limit: Int
    public var str1: String
    public var str2: String

    static var `default` = FizzBuzzRequest(int1: 1, int2: 1, limit: 1, str1: "", str2: "")
}

public struct FizzBuzzStatistics {
    public var mostUsedRequest: FizzBuzzRequest
    public var mostUsedRequestRate: Double
}

public protocol FizzBuzzInteractor {
    func process(request: FizzBuzzRequest) -> FizzBuzzResult
    var statistics: FizzBuzzStatistics? { get }
}

public class FizzBuzzInteractorImplementation: FizzBuzzInteractor {

    public init(statisticsRepository: StatisticsRepository) {
        self.statisticsRepository = statisticsRepository
    }

    public func process(request: FizzBuzzRequest) -> FizzBuzzResult {
        statisticsRepository.record(request: request)
        return FizzBuzzResult(count: request.limit) { index in
            switch (index % request.int1 == 0, index % request.int2 == 0) {
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
            mostUsedRequestRate: Double(mostUsedRequestCount) / Double(statisticsRepository.totalRequestsCount)
        )
    }

    // MARK: - Private

    private let statisticsRepository: StatisticsRepository
}

public protocol StatisticsRepository {
    func record(request: FizzBuzzRequest)
    var mostUsedRequest: FizzBuzzRequest? { get }
    var mostUsedRequestCount: Int? { get }
    var totalRequestsCount: Int { get }
}

public class StatisticsRepositoryImplementation: StatisticsRepository {

    public init() { }

    public func record(request: FizzBuzzRequest) {
        if let requestCount = results[request] {
            results[request] = requestCount + 1
        } else {
            results[request] = 1
        }
    }

    public var mostUsedRequest: FizzBuzzRequest? { mostUsedRequestElement?.key }

    public var mostUsedRequestCount: Int? { mostUsedRequestElement?.value }

    public var totalRequestsCount: Int { results.values.reduce(0) { $0 + $1 } }

    // MARK: - Private

    private var results: [FizzBuzzRequest: Int] = [:]

    private var mostUsedRequestElement: Dictionary<FizzBuzzRequest, Int>.Element? {
        guard
            !results.isEmpty,
            let maxRequestCount = results.values.max(),
            let mostUsedRequestElement = (results.first { $0.value == maxRequestCount }) else { return nil }
        return mostUsedRequestElement
    }
}

extension FizzBuzzRequest: Hashable { }

public struct FizzBuzzResult {
    public let count: Int
    public let valuesProvider: (Int) -> String?
}

extension FizzBuzzResult: RandomAccessCollection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return count }
    public subscript(_ index: Int) -> String? { valuesProvider(index) }
}

class FizzBuzzPresenterImplementation: FizzBuzzPresenter {

    init(fizzBuzzInteractor: FizzBuzzInteractor) {
        self.fizzBuzzInteractor = fizzBuzzInteractor
    }

    var viewContract: FizzBuzzViewContract?

    func start() {
        updateUI()
    }

    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String) {
        self.request = (try? request.update(parameter, with: newValue)) ?? request
        updateUI()
    }

    // MARK: - Private

    private var request = FizzBuzzRequest.default

    private let mapper = FizzBuzzViewModelMapper()

    private let fizzBuzzInteractor: FizzBuzzInteractor

    private func updateUI() {
        let result = fizzBuzzInteractor.process(request: request)
        let statistics = fizzBuzzInteractor.statistics
        let viewModel = mapper.map(request: request, result: result, statistics: statistics)
        viewContract?.display(viewModel: viewModel)
    }
}

enum FizzBuzzError: Error {
    case invalidParameter
}

private extension FizzBuzzRequest {
    func update(_ parameter: FizzBuzzParameter, with stringValue: String) throws -> FizzBuzzRequest {
        var updatedRequest = self
        switch parameter {
        case .int1, .int2, .limit:
            guard
                let updatedValue = Int(stringValue),
                updatedValue > 0,
                let keyPath = parameter.intKeyPath else { throw FizzBuzzError.invalidParameter }
            updatedRequest[keyPath: keyPath] = updatedValue
        case .str1, .str2:
            guard let keyPath = parameter.stringKeyPath else { throw FizzBuzzError.invalidParameter }
            updatedRequest[keyPath: keyPath] = stringValue
        }
        return updatedRequest
    }
}

private extension FizzBuzzParameter {
    var intKeyPath: WritableKeyPath<FizzBuzzRequest, Int>? {
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

struct FizzBuzzViewModelMapper {
    func map(request: FizzBuzzRequest, result: FizzBuzzResult, statistics: FizzBuzzStatistics?) -> FizzBuzzViewModel {
        FizzBuzzViewModel(
            inputParameters: request.parameters,
            values: FizzBuzzViewModel.Values(count: result.count, provider: result.valuesProvider),
            result: statistics.flatMap {
                FizzBuzzViewModel.Result(
                    parameters: $0.mostUsedRequest.parameters,
                    ratio: CGFloat($0.mostUsedRequestRate)
                )
            }
        )
    }
}

private extension FizzBuzzRequest {
    var parameters: FizzBuzzViewModel.Parameters {
        FizzBuzzViewModel.Parameters(
            int1: int1.description,
            int2: int2.description,
            limit: limit.description,
            str1: str1,
            str2: str2
        )
    }
}

extension FizzBuzzViewModel: FizzBuzzViewContract {
    public func display(viewModel: FizzBuzzViewModel) {
        self.inputParameters = viewModel.inputParameters
        self.values = viewModel.values
        self.result = viewModel.result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FizzBuzzView(
            presenter: Self.presenter(for: Self.viewModel),
            viewModel: Self.viewModel
        )
    }

    private static let viewModel = FizzBuzzViewModel.default

    static var statisticsRepository: StatisticsRepository = StatisticsRepositoryImplementation()

    static var fizzBuzzInteratactor: FizzBuzzInteractor = FizzBuzzInteractorImplementation(
        statisticsRepository: Self.statisticsRepository
    )

    static func presenter(for viewModel: FizzBuzzViewContract) -> FizzBuzzPresenter {
        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: Self.fizzBuzzInteratactor)
        presenter.viewContract = viewModel
        return presenter
    }
}
