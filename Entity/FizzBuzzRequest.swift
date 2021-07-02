//
//  FizzBuzzRequest.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// Embed all typed input parameters
public struct FizzBuzzRequest {
    public var int1: Int
    public var int2: Int
    public var limit: Int
    public var str1: String
    public var str2: String

    public init(int1: Int, int2: Int, limit: Int, str1: String, str2: String) {
        self.int1 = int1
        self.int2 = int2
        self.limit = limit
        self.str1 = str1
        self.str2 = str2
    }

    static public var `default` = FizzBuzzRequest(int1: 1, int2: 1, limit: 1, str1: "", str2: "")
}
