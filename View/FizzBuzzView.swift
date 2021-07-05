//
//  FizzBuzzView.swift
//  View
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import SwiftUI

import ViewModel

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
