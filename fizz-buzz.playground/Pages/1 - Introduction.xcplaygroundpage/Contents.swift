//: [Previous](@previous)
/*:
 Let first divide the code in modules, and make those modules independant of each other as much as possible. In that purpose, we will hightly use frameworks and protocols. To begin with, we know we have at least two indepedant modules,
 - the one reponsible for the model of our application,
 - the one reponsible for the user interactions : it could as well be a command line user interface, as well as a graphical user interface.

 Let's call the first one Interactor (as we interact with a model), and the second one Presenter (as we present an application to the user).
 This will give birth to 2 frameworks.
 The boundary between those two modules will lead to the creation of a protocol :
 */

import Entity

public protocol FizzBuzzInteractor {
    /// processes any fizz buzz request and record the operation for statistics purpose
    /// - Parameter request: request
    /// - returns result
    func process(request: FizzBuzzRequest) -> FizzBuzzResult

    var statistics: FizzBuzzStatistics? { get }
}
/*:
 This protocol is therefore defined and specified in the Presenter framework, and the Interactor framework will provide an implementation of it.
 We notice the use of some types here. Those types are the entities, which will give birth to an Entity framework. Those entites are the vehicles for the data going from one module to another.
 Let's create those frameworks, entites and protocol, and let's move to the playground next page.
 */

//: [Next](@next)
