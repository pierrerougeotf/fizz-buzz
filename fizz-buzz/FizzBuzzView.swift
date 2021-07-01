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
    static let accentColor = Color.black
}

enum FizzBuzzParameter {
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
            return viewModel.int1
        case .int2:
            return viewModel.int2
        case .limit:
            return viewModel.limit
        case .str1:
            return viewModel.str1
        case .str2:
            return viewModel.str2
        }
    }
}

protocol FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel)
}

protocol FizzBuzzPresenter {
    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String)
}

public class FizzBuzzViewModel: ObservableObject {
    @Published public var int1: String
    @Published public var int2: String
    @Published public var limit: String
    @Published public var str1: String
    @Published public var str2: String
    @Published public var valuesProvider: (Int) -> String?

    public init(int1: String,
                int2: String,
                limit: String,
                str1: String,
                str2: String,
                valuesProvider: @escaping (Int) -> String?) {
        self.int1 = int1
        self.int2 = int2
        self.limit = limit
        self.str1 = str1
        self.str2 = str2
        self.valuesProvider = valuesProvider
    }
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
                InputView(color: Constants.firstColor, label: Constants.int1Label, valueProxy: int1Proxy)
                InputView(color: Constants.secondColor, label: Constants.int2Label, valueProxy: int2Proxy)
                InputView(color: Constants.accentColor, label: Constants.limitLabel, valueProxy: limitProxy)
                InputView(color: Constants.firstColor, label: Constants.str1Label, valueProxy: str1Proxy)
                InputView(color: Constants.secondColor, label: Constants.str2Label, valueProxy: str2Proxy)
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
                .multilineTextAlignment(.trailing)
        }
    }
}

struct FizzBuzzRequest: Hashable {
    var int1: Int
    var int2: Int
    var limit: Int
    var str1: String
    var str2: String
}

struct FizzBuzzResult {
    let count: Int
    let valuesProvider: (Int) -> String?
}

extension FizzBuzzResult: RandomAccessCollection {
    var startIndex: Int { return 0 }
    var endIndex: Int { return count }
    subscript(_ index: Int) -> String? { valuesProvider(index) }
}

class FizzBuzzPresenterImplementation: FizzBuzzPresenter {

    var viewContract: FizzBuzzViewContract?

    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String) {
        self.request = (try? request.update(parameter, with: newValue)) ?? request
        viewContract?.display(viewModel: mapper.map(request: request, result: result))
    }

    // MARK: - Private
    private var request = FizzBuzzRequest(int1: 1, int2: 2, limit: 3, str1: "str1", str2: "str2")
    private var result = FizzBuzzResult(count: 5) { _ in "tata" }
    private let mapper = FizzBuzzViewModelMapper()
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
    func map(request: FizzBuzzRequest, result: FizzBuzzResult) -> FizzBuzzViewModel {
        FizzBuzzViewModel(
            int1: request.int1.description,
            int2: request.int2.description,
            limit: request.limit.description,
            str1: request.str1,
            str2: request.str2,
            valuesProvider: result.valuesProvider
        )
    }
}

extension FizzBuzzViewModel: FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel) {
        self.int1 = viewModel.int1
        self.int2 = viewModel.int2
        self.limit = viewModel.limit
        self.str1 = viewModel.str1
        self.str2 = viewModel.str2
        self.valuesProvider = viewModel.valuesProvider
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FizzBuzzView(
            presenter: Self.presenter(for: Self.viewModel),
            viewModel: Self.viewModel
        )
    }

    private static let viewModel = FizzBuzzViewModel(
        int1: "3",
        int2: "4",
        limit: "5",
        str1: "three",
        str2: "four",
        valuesProvider: { _ in "toto" }
    )

    static func presenter(for viewModel: FizzBuzzViewContract) -> FizzBuzzPresenter {
        let presenter = FizzBuzzPresenterImplementation()
        presenter.viewContract = viewModel
        return presenter
    }
}
