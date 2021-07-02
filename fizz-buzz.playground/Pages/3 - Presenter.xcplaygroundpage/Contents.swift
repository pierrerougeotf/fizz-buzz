//: [Previous](@previous)

/*:
 For a command line interface, the Presenter logic would probably contain all the user interface logic. However in the case of a graphical user interface, in our case, we will split the logic it 2 frameworks
 - the View framework, very tied to the operating system, holding all the configuration of the UI, the static UI in some way.
 - the Presenter frameowrk itself, handling all the logic of the UI, the "UX", and bridging the model. In the same the Interactor framework does not rely on the operating system, the presenter logic could be cross-platform, in some extents (Kotlin ?…)

 The interactions between the View and Presenter goes both ways:
 - Since the View framework (through SwifUI for this application), captures user events, the View defines a FizzBuzzPresenter protocol, implemented in the Presenter framework, for it to handle user events :
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
public protocol FizzBuzzViewContract {
    func display(viewModel: FizzBuzzViewModel)
}

/*:
 The UI si configured by using a ViewModel type, written by the Presenter ,and read by the View. In the same way the Entity framework is being created to share types between frameworks, A (last) ViewModel framework will be created for the Presenter and View frameworks to access its types
 */
import Combine

public class FizzBuzzViewModel: ObservableObject {

    /// Fizz Buzz parameters as strings
    public struct Parameters {
        public var int1: String
        public var int2: String
        public var limit: String
        public var str1: String
        public var str2: String

        public init(int1: String,
                    int2: String,
                    limit: String,
                    str1: String,
                    str2: String) {
            self.int1 = int1
            self.int2 = int2
            self.limit = limit
            self.str1 = str1
            self.str2 = str2
        }

        public static let `default` = Parameters(int1: "", int2: "", limit: "", str1: "", str2: "")
    }

    /// Result, similar to an array of values
    public struct Result {
        /// array size
        public let count: Int

        /// array values
        public let provider: (Int) -> String?

        public init(count: Int,
                    provider: @escaping (Int) -> String?) {
            self.count = count
            self.provider = provider
        }

        public static let `default` = Result(count: 1) { _ in ""}
    }

    public struct Statistics {
        /// Most used request parameters
        public var parameters: Parameters

        /// Most used request frequancy rate
        public var rate: Double

        public init(parameters: Parameters,
                    rate: Double) {
            self.parameters = parameters
            self.rate = rate
        }

        public static let `default` = Statistics(parameters: Parameters.default, rate: 0.0)
    }

    /// Input parameters
    @Published public var input: Parameters

    /// Fizz buzz result for input parameters
    @Published public var result: Result

    /// statistics for most used request
    @Published public var statistics: Statistics?

    public static let `default` = FizzBuzzViewModel(input: .default, result: .default, statistics: nil)

    public init(input: Parameters,
                result: Result,
                statistics: Statistics?) {
        self.input = input
        self.result = result
        self.statistics = statistics
    }
}



/*:
 Let's create the frameworks, structure and protocol
 */

//: [Next](@next)
