//
//  ResultView.swift
//  View
//
//  Created by Pierre Rougeot on 05/07/2021.
//

import SwiftUI

import ViewModel

struct ResultView: View {
    let result: ResultViewModel

    // MARK: - View

    var body: some View {
        switch result {
        case .irrelevant:
            Text("empty_result".localized())
        case let .values(values):
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top) {
                    ForEach(values, id: \.id) { element in
                        VStack {
                            Text(String(element.id))
                            Text(element.value)
                        }
                    }
                }
            }
        }
    }
}

extension ResultViewModel.Values: RandomAccessCollection {
    public var startIndex: Int { return 1 }
    public var endIndex: Int { return count }
    public subscript(_ index: Int) -> (id: Int, value: String) { (id: index, value: provider(index) ?? "") }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(result: .values(ResultViewModel.Values(count: 50) { _ in "T" }))
    }
}
