//
//  StatisticsViewModel.swift
//  ViewModel
//
//  Created by Pierre Rougeot on 04/07/2021.
//

/// This view model is the configuration of the statistic view
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
