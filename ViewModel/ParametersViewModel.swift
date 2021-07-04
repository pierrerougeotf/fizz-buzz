//
//  InputViewModel.swift
//  ViewModel
//
//  Created by Pierre Rougeot on 04/07/2021.
//

public struct InputViewModel {
    public let int1: String
    public let int2: String
    public let limit: String
    public let str1: String
    public let str2: String

    public init(int1: String, int2: String, limit: String, str1: String, str2: String) {
        self.int1 = int1
        self.int2 = int2
        self.limit = limit
        self.str1 = str1
        self.str2 = str2
    }

    public static let empty = Self(int1: "", int2: "", limit: "", str1: "", str2: "")
}
