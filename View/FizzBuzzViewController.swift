//
//  FizzBuzzViewController.swift
//  View
//
//  Created by Pierre Rougeot on 09/07/2021.
//

import UIKit

import ViewModel

public class FizzBuzzViewController: UIViewController {

    public static var fromNib: FizzBuzzViewController {
        FizzBuzzViewController(
            nibName: "\(Self.self)".components(separatedBy: ".").last!,
            bundle: Bundle(for: Self.self)
        )
    }

    public var presenter: FizzBuzzPresenter?

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.start()
    }

    // MARK: - ViewContract

    public func display(viewModel: FizzBuzzViewModel) {
        inputs?.forEach {
            guard let parameter = $0.parameter else { return }
            $0.text = viewModel.input[keyPath: parameter.viewModelkeyPath]
        }

        switch viewModel.result {
        case .irrelevant:
            result.text = "Irrelevant"
        case let .values(provider):
            result.text = "1: \(provider.provider(1) ?? "")…"
        }

        // TODO (Pierre Rougeot) 09/07/2021 Complete View
    }

    // MARK: - Internal

    @IBAction func didUpdateParameter(_ sender: UITextField) {
        guard let parameter = sender.parameter else { return }
        presenter?.requestUpdate(of: parameter, to: sender.text ?? "")
    }

    // MARK: - Private

    @IBOutlet private var inputs: [UITextField]!
    @IBOutlet private var result: UILabel!
}

private extension UITextField {
    var parameter: FizzBuzzParameter? {
        switch TextFieldTag(rawValue: tag) {
        case .int1?:
            return .int1
        case .int2?:
            return .int2
        case .limit?:
            return .limit
        case .str1?:
            return .str1
        case .str2?:
            return .str2
        default:
            return nil
        }
    }

    // MARK: - Private

    private enum TextFieldTag: Int {
        case int1 = 0
        case int2
        case limit
        case str1
        case str2
    }
}

private extension FizzBuzzParameter {
    var viewModelkeyPath: KeyPath<ParametersViewModel, String> {
        switch self {
        case .int1:
            return \.int1
        case .int2:
            return \.int2
        case .limit:
            return \.limit
        case .str1:
            return \.str1
        case .str2:
            return \.str2
        }
    }
}
