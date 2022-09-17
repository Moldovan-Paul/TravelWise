import UIKit

class PersonInputView: InputView {

    private(set) var adultCount = 1
    var personLabel: String = "" {
        didSet {
            labelText = personLabel
        }
    }


    override func commonInit() {
        super.commonInit()
        delegate = self
        keyboardType = .numberPad
        labelText = "PASSENGERS"
        inputText = "1 Adult"
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "\(adultCount)"
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let length = textField.text?.count, let range = textField.selectedTextRange else {
            return false
        }

        let startingPosition = textField.offset(from: textField.beginningOfDocument, to: range.start)
        let endingPosition = textField.offset(from: textField.beginningOfDocument, to: range.end)

        if startingPosition == 0 && endingPosition == 2 ||
            string.isEmpty { // if replacementString is empty -> backspace
            return true
        }

        return length < 2
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        adultCount = Int(textField.text ?? "") ?? 0
        if adultCount > 1 {
            textField.text = "\(adultCount) Adults"
        } else {
            textField.text = "1 Adult"
        }
    }
}
