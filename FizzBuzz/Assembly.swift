//
//  Assembly.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import Foundation

import Repository
import Interactor
import Presenter
import View

extension Repository.StatisticsRepositoryImplementation: Interactor.StatisticsRepository { }
extension Interactor.FizzBuzzInteractorImplementation: Presenter.FizzBuzzInteractor { }
extension Presenter.FizzBuzzPresenterImplementation: View.FizzBuzzPresenter { }
extension View.FizzBuzzViewController: Presenter.FizzBuzzViewContract { }
