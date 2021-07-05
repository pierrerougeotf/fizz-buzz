//
//  StatisticsView.swift
//  View
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import SwiftUI

import ViewModel

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

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(statistics: .irrelevant)
        StatisticsView(
            statistics: .data(
                StatisticsViewModel.Data(
                    parameters: ParametersViewModel(int1: "56", int2: "22", limit: "45", str1: "RO", str2: "T"),
                    ratioDegrees: 270,
                    description: "50 % ( 2 / 4")
            )
        )
    }
}
