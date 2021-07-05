//
//  InputView.swift
//  View
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import SwiftUI

struct InputView: View {
    let color: Color
    let label: String
    let valueProxy: Binding<String>

    // MARK: - View

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
                .multilineTextAlignment(.leading)
                .foregroundColor(color)
        }
    }
}

struct InputView_Previews: PreviewProvider {

    static var previews: some View {
        InputView(color: .red, label: "Test", valueProxy: Binding<String>(get: { "Value" }, set: { _ in }))
    }
}
