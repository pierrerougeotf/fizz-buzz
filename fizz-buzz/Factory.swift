//
//  Factory.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Repository
import Interactor
import Presenter
import View

enum Factory {
    static let statisticsRepository: StatisticsRepository = StatisticsRepositoryImplementation()
    static let fizzBuzzInteractor: FizzBuzzInteractor = FizzBuzzInteractorImplementation(
        statisticsRepository: statisticsRepository
    )
    static let (fizzBuzzPresenter, fizzBuzzView): (FizzBuzzPresenter, FizzBuzzView) = {
        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: fizzBuzzInteractor)
        let view = FizzBuzzView(presenter: presenter)
        presenter.viewContract = view
        return (presenter, view)
    }()
}
