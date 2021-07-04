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

    public init(int1: String, int2: String, limit: String, str1: String, str2: String) {
        self.int1 = int1
        self.int2 = int2
        self.limit = limit
        self.str1 = str1
        self.str2 = str2
    }

    public static let empty = Self(int1: "", int2: "", limit: "", str1: "", str2: "")
}

// ResultViewModel.swift
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

// StatisticsViewModel.swift
public enum StatisticsViewModel {

    public struct Data {
        public let parameters: ParametersViewModel
        public let ratioDegrees: Double
        public let description: String

        public init(parameters: ParametersViewModel, ratioDegrees: Double, description: String) {
            self.parameters = parameters
            self.ratioDegrees = ratioDegrees
            self.description = description
        }
    }

    case irrelevant
    case data(Data)
}

// FizzBuzzViewModel
public struct FizzBuzzViewModel {
    public let input: ParametersViewModel
    public let result: ResultViewModel
    public let statistics: StatisticsViewModel

    public static let empty = Self(input: .empty, result: .irrelevant, statistics: .irrelevant)
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
    let result: ResultViewModel

    // MARK: - View

    var body: some View {
        switch result {
        case .irrelevant:
            Text("empty_result".localized())
        case let .values(values):
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(values, id: \.id) { element in
                        VStack {
                            Text(String(element.id))
                            Text(element.value)
                        }
                    }
                }
            }
        }
    }
}

extension ResultViewModel.Values: RandomAccessCollection {
    public var startIndex: Int { return 1 }
    public var endIndex: Int { return count }
    public subscript(_ index: Int) -> (id: Int, value: String) { (id: index, value: provider(index) ?? "") }
}


// StatisticsView.swift
import SwiftUI

struct StatisticsView: View {
    let statistics: StatisticsViewModel

    // MARK: - View

    var body: some View {
        switch statistics {
        case .irrelevant:
            Text("empty_statistics".localized())
        case let .data(data):
            HStack {
                Text(data.resultText)
                VStack {
                    Pie(endAngle: Angle(degrees: -data.ratioDegrees))
                    Text(data.description)
                }
            }
        }
    }
}

private extension StatisticsViewModel.Data {

    var resultText: String {
        """

        -\("int1_label".localized()): \(parameters.int1)
        -\("int2_label".localized()): \(parameters.int2)
        -\("str1_label".localized()): \(parameters.str1)
        -\("str2_label".localized()): \(parameters.str2)
        -\("limit_label".localized()): \(parameters.limit)

        """
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

    public init(presenter: FizzBuzzPresenter?, viewModel: FizzBuzzViewModel = .empty) {
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
                    ResultView(result: viewModel.result)
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
    @Published var statistics: StatisticsViewModel

    required init(input: ParametersViewModel,
                  result: ResultViewModel,
                  statistics: StatisticsViewModel) {
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
    public var int1: Int?
    public var int2: Int?
    public var limit: Int?
    public var str1: String
    public var str2: String

    public static var empty = FizzBuzzRequest(int1: nil, int2: nil, limit: nil, str1: "", str2: "")

    public var isValid: Bool {
        guard
            let int1 = int1,
            let int2 = int2,
            let limit = limit,
            int1 > 0,
            int2 > 0,
            limit > 0,
            limit < Int.max - 1 else {
            return false
        }
        return true
    }


}

// FizzBuzzResult.swift
public struct FizzBuzzResult {
    /// Number of relevant indexes, first index being 1
    public let count: Int

    /// Values, relevant for index in 1...count
    public let provider: (Int) -> String?

    static let empty = FizzBuzzResult(count: 0, provider: { _ in nil } )

    public var isRelevant: Bool { count > 0 }
}

// FizzBuzzStatistics.swift
public struct FizzBuzzStatistics {
    public var mostUsedRequest: FizzBuzzRequest
    public var mostUsedRequestCount: Int
    public var totalRequestsCount: Int
    public var mostUsedRequestRate: Double

    public var isRelevant: Bool { mostUsedRequest.isValid }
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
                    description: Int(rate * 100).description + " % (\(mostUsedRequestCount) / \(totalRequestsCount))"
                )
            )
        } else {
            return .irrelevant
        }
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
        updateUI(for: self.request)
    }

    public func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String) {
        let updatedRequest = request.update(parameter, with: newValue)
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
    func update(_ parameter: FizzBuzzParameter, with stringValue: String) -> FizzBuzzRequest? {
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

    var validOrNilRequest: FizzBuzzRequest? { isValid ? self : nil}
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
        guard request.isValid,
              let int1 = request.int1,
              let int2 = request.int2,
              let limit = request.limit else { return .empty }
        statisticsRepository.record(request: request)
        return FizzBuzzResult(count: limit + 1) { index in
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        fizzBuzzView
    }
}
