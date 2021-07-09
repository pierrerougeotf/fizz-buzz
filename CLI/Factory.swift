//
//  Factory.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Repository
import Interactor

enum Factory {
    static let statisticsRepository: StatisticsRepository = StatisticsRepositoryImplementation()
    static let fizzBuzzInteractor: FizzBuzzInteractor = FizzBuzzInteractorImplementation(
        statisticsRepository: statisticsRepository
    )
}
