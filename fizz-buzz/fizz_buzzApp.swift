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
            let viewModel = FizzBuzzViewModel(
                int1: "0",
                int2: "0",
                limit: "0",
                str1: "",
                str2: "",
                valuesProvider: { _ in "titi"}
            )
            FizzBuzzView(presenter: nil, viewModel: viewModel)
        }
    }
}
