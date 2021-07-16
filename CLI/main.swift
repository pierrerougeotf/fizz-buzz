//
//  main.swift
//  CLI
//
//  Created by Pierre Rougeot on 09/07/2021.
//

import ArgumentParser

import Entity
import Interactor

struct FizzBuzz: ParsableCommand {
    @Argument(help: "int1")
    var int1: Int

    @Argument(help: "int2")
    var int2: Int

    @Argument(help: "limit")
    var limit: Int

    @Argument(help: "str1")
    var str1: String

    @Argument(help: "str2")
    var str2: String

    mutating func run() throws {

        let request = FizzBuzzRequest(int1: int1, int2: int2, limit: limit, str1: str1, str2: str2)

        let result = Factory.fizzBuzzInteractor.process(request: request)

        for i in 1...result.count {
            if let value = result.provider(i) {
                print("\(i): \(value)")
            }
        }
    }
}

FizzBuzz.main()

