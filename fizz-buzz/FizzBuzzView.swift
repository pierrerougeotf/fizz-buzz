//
//  FizzBuzzView.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 28/06/2021.
//

import SwiftUI

private enum Constants {
    static let firstColor = Color("PrimaryColor")
    static let secondColor = Color("SecondaryColor")
    static let accentColor = Color("AccentColor")
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
            return viewModel.input.int1
        case .int2:
            return viewModel.input.int2
        case .limit:
            return viewModel.input.limit
        case .str1:
            return viewModel.input.str1
        case .str2:
            return viewModel.input.str2
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

    public struct Result {
        public let count: Int
        public let provider: (Int) -> String?

        public static let `default` = Result(count: 1) { _ in ""}
    }

    public struct Statistics {
        public var parameters: Parameters
        public var rate: CGFloat

        static let `default` = Statistics(parameters: Parameters.default, rate: 0.0)
    }

    @Published public var input: Parameters
    @Published public var result: Result
    @Published public var statistics: Statistics?

    static let `default` = FizzBuzzViewModel(input: .default, result: .default, statistics: nil)

    public init(input: Parameters,
                result: Result,
                statistics: Statistics?) {
        self.input = input
        self.result = result
        self.statistics = statistics
    }
}

extension FizzBuzzViewModel.Result: RandomAccessCollection {
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
                Section(header: Text("input_section_title".localized())) {
                    InputView(color: Constants.firstColor, label: "int1_label".localized(), valueProxy: int1Proxy)
                    InputView(color: Constants.secondColor, label: "int2_label".localized(), valueProxy: int2Proxy)
                    InputView(color: Constants.firstColor, label: "str1_label".localized(), valueProxy: str1Proxy)
                    InputView(color: Constants.secondColor, label: "str2_label".localized(), valueProxy: str2Proxy)
                    InputView(color: Constants.accentColor, label: "limit_label".localized(), valueProxy: limitProxy)
                }

                Section(header: Text("result_section_title".localized())) {
                    ResultView(values: viewModel.result)
                }

                Section(header: Text("statistics_section_title".localized())) {
                    StatisticsView(statistics: viewModel.statistics)
                }
            }
            .navigationBarTitle("app_title".localized())
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
            input: request.parameters,
            result: FizzBuzzViewModel.Result(count: result.count, provider: result.valuesProvider),
            statistics: statistics.flatMap {
                FizzBuzzViewModel.Statistics(
                    parameters: $0.mostUsedRequest.parameters,
                    rate: CGFloat($0.mostUsedRequestRate)
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
        self.input = viewModel.input
        self.result = viewModel.result
        self.statistics = viewModel.statistics
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

struct ResultView: View {
    let values: FizzBuzzViewModel.Result

    var body: some View {
        ScrollView(.horizontal) {
            if values.count > 1 {
                LazyHStack {
                    ForEach(1..<values.count, id: \.self) { index in
                        if let value = values.provider(index) {
                            VStack {
                                Text(String(index))
                                Text(value)
                            }
                        }
                    }
                }
            } else {
                Text("empty_result".localized())
            }
        }
    }
}

struct StatisticsView: View {
    let statistics: FizzBuzzViewModel.Statistics?

    var body: some View {
        HStack {
            Text(resultText ?? "empty_statistics".localized())
            VStack {
                Pie(startAngle: Angle(degrees: 0.0), endAngle: Angle(degrees: ratioDegrees))
                Text(ratioPercentageLabel)
            }
        }
    }

    // MARK: - Private

    var ratioDegrees: Double { -Double(statistics?.rate ?? 0.0) * 360.0 }

    var ratioPercentageLabel: String { statistics.flatMap { Int($0.rate * 100).description + " %"} ?? "" }

    var resultText: String? {
        statistics.flatMap {
            """

            -\("int1_label".localized()): \($0.parameters.int1)
            -\("int2_label".localized()): \($0.parameters.int2)
            -\("str1_label".localized()): \($0.parameters.str1)
            -\("str2_label".localized()): \($0.parameters.str2)
            -\("limit_label".localized()): \($0.parameters.limit)

            """
        }
    }
}
