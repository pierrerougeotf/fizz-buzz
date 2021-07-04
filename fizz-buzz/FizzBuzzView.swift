//
//  FizzBuzzView.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 28/06/2021.
//

//
// ViewModel
//

// ParametersViewModel.swift

public struct ParametersViewModel {
    public let int1: String
    public let int2: String
    public let limit: String
    public let str1: String
    public let str2: String

    public static let `default` = Self(int1: "", int2: "", limit: "", str1: "", str2: "")
}

// ResultViewModel.swift
public struct ResultViewModel {
    public let count: Int
    public let provider: (Int) -> String?

    public static let `default` = Self(count: 1) { _ in ""}
}

// StatisticsViewModel.swift
public struct StatisticsViewModel {
    public let parameters: ParametersViewModel
    public let rate: CGFloat

    public static let `default` = Self(parameters: .default, rate: 0.0)
}

// FizzBuzzViewModel
public struct FizzBuzzViewModel {
    public let input: ParametersViewModel
    public let result: ResultViewModel
    public let statistics: StatisticsViewModel?

    public static let `default` = Self(input: .default, result: .default, statistics: nil)
}

//
// End ViewModel
//

//
// View
//

// FizzBuzzPresenter.swift
public enum FizzBuzzParameter {
    case int1
    case int2
    case limit
    case str1
    case str2
}

public protocol FizzBuzzPresenter {
    func start()
    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String)
}

// InputView.swift
import SwiftUI

struct InputView: View {
    let color: Color
    let label: String
    let valueProxy: Binding<String>

    // MARK: - View

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


// ResultView.swift
import SwiftUI

struct ResultView: View {
    let values: ResultViewModel

    // MARK: - View

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

// StatisticsView.swift
import SwiftUI

struct StatisticsView: View {
    let statistics: StatisticsViewModel?

    // MARK: - View

    var body: some View {
        HStack {
            Text(resultText ?? "empty_statistics".localized())
            VStack {
                Pie(endAngle: Angle(degrees: ratioDegrees))
                Text(ratioPercentageLabel)
            }
        }
    }

    // MARK: - Private

    private var ratioDegrees: Double { -Double(statistics?.rate ?? 0.0) * 360.0 }
    private var ratioPercentageLabel: String { statistics.flatMap { Int($0.rate * 100).description + " %"} ?? "" }
    private var resultText: String? {
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

private struct Pie: Shape {
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(0.0)),
            y: center.y + radius * CGFloat(sin(0.0))
        )

        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center, radius: radius, startAngle: Angle(radians: 0.0), endAngle: -endAngle, clockwise: false)
        p.addLine(to: center)
        return p
    }
}

// FizzBuzzView.swift
import SwiftUI

private enum Constants {
    static let firstColor = Color("PrimaryColor")
    static let secondColor = Color("SecondaryColor")
    static let accentColor = Color("AccentColor")
}

public struct FizzBuzzView: View {

    public init(presenter: FizzBuzzPresenter?, viewModel: FizzBuzzViewModel = .default) {
        self.presenter = presenter
        self.viewModel = FizzBuzzViewModelProxy(
            input: viewModel.input,
            result: viewModel.result,
            statistics: viewModel.statistics
        )
    }

    // MARK: - FizzBuzzViewContract

    public func display(viewModel: FizzBuzzViewModel) {
        self.viewModel.configure(with: viewModel)
    }

    // MARK: - View

    public var body: some View {
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

    // MARK: - Private

    private var presenter: FizzBuzzPresenter?

    private var int1Proxy: Binding<String> { binding(for: .int1, of: viewModel) }
    private var int2Proxy: Binding<String> { binding(for: .int2, of: viewModel) }
    private var limitProxy: Binding<String> { binding(for: .limit, of: viewModel) }
    private var str1Proxy: Binding<String> { binding(for: .str1, of: viewModel) }
    private var str2Proxy: Binding<String> { binding(for: .str2, of: viewModel) }

    @ObservedObject private var viewModel: FizzBuzzViewModelProxy

    private func binding(for parameter: FizzBuzzParameter, of viewModel: FizzBuzzViewModelProxy) -> Binding<String> {
        Binding<String> {
            parameter.value(for: viewModel)
        } set: {
            presenter?.requestUpdate(of: parameter, to: $0)
        }
    }
}

private class FizzBuzzViewModelProxy: ObservableObject {

    @Published var input: ParametersViewModel
    @Published var result: ResultViewModel
    @Published var statistics: StatisticsViewModel?

    required init(input: ParametersViewModel,
                  result: ResultViewModel,
                  statistics: StatisticsViewModel?) {
        self.input = input
        self.result = result
        self.statistics = statistics
    }
}

private extension FizzBuzzViewModelProxy {
    func configure(with viewModel: FizzBuzzViewModel) {
        input = viewModel.input
        result = viewModel.result
        statistics = viewModel.statistics
    }
}

private extension FizzBuzzParameter {
    func value(for viewModel: FizzBuzzViewModelProxy) -> String {
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

//
// End View
//

//
// Entity
//

// FizzBuzzRequest.swift
public struct FizzBuzzRequest {
    public var int1: Int
    public var int2: Int
    public var limit: Int
    public var str1: String
    public var str2: String

    public static var `default` = FizzBuzzRequest(int1: 1, int2: 1, limit: 1, str1: "", str2: "")
}

// FizzBuzzResult.swift
public struct FizzBuzzResult {
    public let count: Int
    public let valuesProvider: (Int) -> String?
}

// FizzBuzzStatistics.swift
public struct FizzBuzzStatistics {
    public var mostUsedRequest: FizzBuzzRequest
    public var mostUsedRequestRate: Double
}

//
// End Entity
//

//
// Presenter
//

// FizzBuzzInteractor.swift
public protocol FizzBuzzInteractor {
    func process(request: FizzBuzzRequest) -> FizzBuzzResult
    var statistics: FizzBuzzStatistics? { get }
}

// FizzBuzzViewContract.swift
public protocol FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel)
}

// FizzBuzzViewModelMapper.swift
struct FizzBuzzViewModelMapper {
    func map(request: FizzBuzzRequest, result: FizzBuzzResult, statistics: FizzBuzzStatistics?) -> FizzBuzzViewModel {
        FizzBuzzViewModel(
            input: request.parameters,
            result: ResultViewModel(count: result.count, provider: result.valuesProvider),
            statistics: statistics.flatMap {
                StatisticsViewModel(
                    parameters: $0.mostUsedRequest.parameters,
                    rate: CGFloat($0.mostUsedRequestRate)
                )
            }
        )
    }
}

private extension FizzBuzzRequest {
    var parameters: ParametersViewModel {
        ParametersViewModel(
            int1: int1.description,
            int2: int2.description,
            limit: limit.description,
            str1: str1,
            str2: str2
        )
    }
}

// FizzBuzzPresenterImplementation.swift
public class FizzBuzzPresenterImplementation {
    public init(fizzBuzzInteractor: FizzBuzzInteractor) {
        self.fizzBuzzInteractor = fizzBuzzInteractor
    }

    public var viewContract: FizzBuzzViewContract?

    // MARK: - FizzBuzzPresenter

    public func start() {
        updateUI()
    }

    public func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String) {
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

private enum FizzBuzzError: Error {
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

//
// End Presenter
//

//
// Interactor
//

// StatisticsRepository.swift
public protocol StatisticsRepository {
    func record(request: FizzBuzzRequest)
    var mostUsedRequest: FizzBuzzRequest? { get }
    var mostUsedRequestCount: Int? { get }
    var totalRequestsCount: Int { get }
}

// FizzBuzzInteractorImplementation.swit
public class FizzBuzzInteractorImplementation {
    public init(statisticsRepository: StatisticsRepository) {
        self.statisticsRepository = statisticsRepository
    }

    // MARK: - FizzBuzzInteractor

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

//
// End Interactor
//

//
// Repository
//

public class StatisticsRepositoryImplementation {

    public init() { }

    // MARK: - StatisticsRepository

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

//
// End Repository
//

//
// App
//

// Assembly.swift
extension StatisticsRepositoryImplementation: StatisticsRepository { }
extension FizzBuzzInteractorImplementation: FizzBuzzInteractor { }
extension FizzBuzzPresenterImplementation: FizzBuzzPresenter { }
extension FizzBuzzView: FizzBuzzViewContract { }

// Factory.swift
let statisticsRepository: StatisticsRepository = StatisticsRepositoryImplementation()
let fizzBuzzInteractor: FizzBuzzInteractor = FizzBuzzInteractorImplementation(
    statisticsRepository: statisticsRepository
)
let (fizzBuzzPresenter, fizzBuzzView): (FizzBuzzPresenter, FizzBuzzView) = {
    let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: fizzBuzzInteractor)
    let view = FizzBuzzView(presenter: presenter)
    presenter.viewContract = view
    return (presenter, view)
}()

//
// End App
//

//extension FizzBuzzResult: RandomAccessCollection {
//    public var startIndex: Int { return 0 }
//    public var endIndex: Int { return count }
//    public subscript(_ index: Int) -> String? { valuesProvider(index) }
//}


//extension FizzBuzzViewModel: FizzBuzzViewContract {
//    public func display(viewModel: FizzBuzzViewModel) {
//        self.input = viewModel.input
//        self.result = viewModel.result
//        self.statistics = viewModel.statistics
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        fizzBuzzView
    }
}

//extension FizzBuzzViewModel.Result: RandomAccessCollection {
//    public var startIndex: Int { return 0 }
//    public var endIndex: Int { return count }
//    public subscript(_ index: Int) -> (id: Int, value: String) { (id: index, value: provider(index) ?? "") }
//}
