//: [Previous](@previous)
/*:
 Let first divide the code in modules, and make those modules independants as much as possible. In that purpose, we will hightly use frameworks and protocols. For instance, we know we hae at least two indepedant modules, the one reponsible for the model of our application, and the one reponsible for the user interactions : it could be a command line user interface or a graphical user
 interface Let's call the first one Presenter, and the second one Interactor. This gives birth to 2 frameworks. The boundary between those two modules will lead to the creation of a protocol :
 */
public protocol FizzBuzzInteractor {
    associatedtype FizzBuzzRequest
    associatedtype FizzBuzzResult
    associatedtype FizzBuzzStatistics

    /// processes any fizz buzz request and record the operation for statistics purpose
    /// - Parameter request: request
    /// - returns result
    func process(request: FizzBuzzRequest) -> FizzBuzzResult

    var statistics: FizzBuzzStatistics? { get }
}
/*:
 This protocol is therefore defined and specified in the Presenter framework, and the Interactor framework will provide an implementation of it.

 We notice the use of some types here. Those types are the entities, which will give birth to an Entity framework. Those entites are the vehicles for the data going from one module to ahother.

 Let's create those frameworks, entites and protocol
 */

//: [Next](@next)
