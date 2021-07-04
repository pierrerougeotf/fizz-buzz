//
//  fizz_buzzApp.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 28/06/2021.
//

import SwiftUI

@main
struct fizz_buzzApp: App {
    var body: some Scene {
        WindowGroup {
            fizzBuzzView
        }
    }

    // MARK: - Private


    private static let viewModel = FizzBuzzViewModel.default

    static var statisticsRepository: StatisticsRepository = StatisticsRepositoryImplementation()

    static var fizzBuzzInteratactor: FizzBuzzInteractor = FizzBuzzInteractorImplementation(
        statisticsRepository: Self.statisticsRepository
    )

    static func presenter(for viewModel: FizzBuzzViewContract) -> FizzBuzzPresenter {
        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: Self.fizzBuzzInteratactor)
        presenter.viewContract = viewModel
        presenter.start()
        return presenter
    }
}
