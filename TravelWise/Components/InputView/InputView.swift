import UIKit

class InputView: CustomView, UITextFieldDelegate {
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private weak var label: UILabel!

    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }

    var inputText: String = "" {
        didSet {
            textField.text = inputText
        }
    }

    @IBInspectable var labelText: String = "InputView placeholder text" {
        didSet {
            label.text = labelText.uppercased()
        }
    }

    @IBInspectable var inputPlaceholder: String = "" {
        didSet {
            textField.placeholder = inputPlaceholder
        }
    }

    var autocapitalizationType: UITextAutocapitalizationType = .sentences {
        didSet {
            textField.autocapitalizationType = autocapitalizationType
        }
    }

    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
}
