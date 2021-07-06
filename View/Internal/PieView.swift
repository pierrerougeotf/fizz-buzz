//
//  PieView.swift
//  View
//
//  Created by Pierre Rougeot on 06/07/2021.
//

import SwiftUI
import UIKit

struct PieView: UIViewRepresentable {

    @State var rate: Double

    func makeUIView(context: Context) -> PieUIView {
        PieUIView()
    }

    func updateUIView(_ uiView: PieUIView, context: Context) {
        uiView.rate = CGFloat(rate)
    }
}


@IBDesignable
class PieUIView: UIView {

    @IBInspectable
    var rate: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        StyleKit.drawPie(frame: rect, resizing: .aspectFit, rate: rate)
    }
}

struct PieView_Previews: PreviewProvider {
    static var previews: some View {
        PieView(rate: 0.63)
    }
}
