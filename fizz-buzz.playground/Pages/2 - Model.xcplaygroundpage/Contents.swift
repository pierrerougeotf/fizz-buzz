//: [Previous](@previous)
/*:
 Whereas the model of the application could, for a simple application like the current one, all stand in our interactor framework, we make the choice to split this domain in two modules :
 - one responsible for the logic of the model, stateless, mostly independant of the operating system in some way, cross-platform at some extents. All business rules stand in this module.
 - one, we will name the Repository framework, responsible for the sources and destinations of the data (the entities). This framework will be highly tied to the operating system, weither it is using files, databases, or network resources.

 In the implementation of our FizzBuzzInteractor, we will have to register all fizz buzz processing counts, for statistics. The boundary between the Interactor and Repository framework will therefore give birth to the following protocol, defined in the Interactor framework, and implemented in the Repository framework
 */

import Entity

public protocol StatisticsRepository {
    func record(request: FizzBuzzRequest)
    var mostUsedRequest: FizzBuzzRequest? { get }
    var mostUsedRequestCount: Int? { get }
    var totalRequestsCount: Int { get }
}

/*:
 Let's create the Interactor framework, and required protocol and then move to the next playground mage
 */

//: [Next](@next)
