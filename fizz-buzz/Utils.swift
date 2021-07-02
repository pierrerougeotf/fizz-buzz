//
//  Utils.swift
//  fizz-buzz
//
//  Created by Pierre Rougeot on 02/07/2021.
//

import Foundation

extension String {

    /**
     Syntaxic sugar for NSLocalizedString
     */
    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
