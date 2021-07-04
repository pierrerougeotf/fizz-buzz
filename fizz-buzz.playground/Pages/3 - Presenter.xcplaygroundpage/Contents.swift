//: [Previous](@previous)

/*:
 For a command line interface, the Presenter logic would probably contain all the user interface logic. However in the case of a graphical user interface, in our case, we will split the logic it 2 frameworks
 - the View framework, very tied to the operating system, holding all the configuration of the UI, the static UI in some way.
 - the Presenter frameowrk itself, handling all the logic of the UI, the "UX", and bridging the model. In the same way the Interactor framework does not rely on the operating system, the presenter logic could be cross-platform, in some extents (Kotlin ?…)

 The interactions between the View and Presenter goes both ways:
 - Since the View framework , captures user events, the View defines a FizzBuzzPresenter protocol, implemented in the Presenter framework, for it to handle user events :
 */

public enum FizzBuzzParameter {
    case int1
    case int2
    case limit
    case str1
    case str2
}

public protocol FizzBuzzPresenter {
    /// Asks the presenter to go to init state
    func start()

    /// A FizzBuzz input parameter has changed, asks for and update
    /// - Parameters:
    ///   - parameter: the parameter having changed
    ///   - newValue: the value of the parameter being captured
    func requestUpdate(of parameter: FizzBuzzParameter, to newValue: String)
}

/*:
 - The Presenter framework will need to configure the UI, through a new protocol. We will name it ViewContract. This protocol will therefore be defined in the Presenter framework, and implemented by the View framework
*/

import ViewModel

public protocol FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel)
}

/*:
 The UI si configured by using a ViewModel type, written by the Presenter, and read by the View. In the same way the Entity framework is being created to share types between frameworks, A (last) ViewModel framework will be created for the Presenter and View frameworks to access its types
 */


/*:
 Let's create the frameworks, structure and protocol
 */

//: [Next](@next)
