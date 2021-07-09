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
    static let (fizzBuzzPresenter, fizzBuzzViewController): (FizzBuzzPresenter, FizzBuzzViewController) = {
        let presenter = FizzBuzzPresenterImplementation(fizzBuzzInteractor: fizzBuzzInteractor)
        let viewController = FizzBuzzViewController.fromNib
        viewController.presenter = presenter
        presenter.viewContract = viewController
        return (presenter, viewController)
    }()
}
