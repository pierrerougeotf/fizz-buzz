//
//  Assembly.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Foundation

import Repository
import Interactor

extension Repository.StatisticsRepositoryImplementation: Interactor.StatisticsRepository { }
extension Interactor.FizzBuzzInteractorImplementation: FizzBuzzInteractor { }
