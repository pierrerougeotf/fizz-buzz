//
//  FizzBuzzRequest.swift
//  Entity
//
//  Created by Pierre Rougeot on 02/07/2021.
//

/// Embed all typed input parameters
public struct FizzBuzzRequest {
    public var int1: Int?
    public var int2: Int?
    public var limit: Int?
    public var str1: String
    public var str2: String

    public static var empty = FizzBuzzRequest(int1: nil, int2: nil, limit: nil, str1: "", str2: "")

    /// Ensure a request will provide a result.
    /// zero values are forbidden, as well as Int.max for limit parameter
    public var isValid: Bool {
        guard
            let int1 = int1,
            let int2 = int2,
            let limit = limit,
            int1 > 0,
            int2 > 0,
            limit > 0,
            limit < Int.max - 1 else {
            return false
        }
        return true
    }
}
