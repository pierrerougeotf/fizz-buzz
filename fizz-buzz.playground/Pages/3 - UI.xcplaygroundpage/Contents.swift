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
 Let's create the frameworks, structure and protocol, and let's have a look at the overall architecture drawing (Architecture.png) before moving to the creation of the Repository framework and the implementation of the StatisticsRepositoryImplementation class and unit tests

 ![The global frameworks architecture](Architecture.png)

 Even though the number of frameworks and modules may seem a litlle bit complex for such a simple project, it shows how multiple developers could easily work together simultaneously on some complex ones, without any disturbance. This architecture allows any update from a GUI to a command line interface for instance. Alternatively we also could easily update the View framework, to move from Swift UI to UIKit, without touching any line of code of the other frameworks.
 Every boundary, protocol  can however be removed, any frameworks can be merged, if required,
 */

/*:
 Let's create the tests and implementation in the Interactor framework
 */

/*:
 Let's create the tests and implementations in the Presenter framework
 */

/*:
 Let's create the views
 */

/*:
 Let's create the Assemby.swift file, in charge of ensuring all the protocol conformances, and the Factory.swift, in charge of instanciating all structures.
 */


//: [Next](@next)
