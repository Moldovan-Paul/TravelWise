import UIKit

protocol LocationPopoverViewControllerDelegate: AnyObject {
    func openPopover()
    func setLocationId(_ locationId: String)
    func setLocation(_ location: String)
}

protocol LocationPopoverDelegate: AnyObject {
    func dismissPopover()
    func fetch(data: [SuggestionTableViewCellModel])
}

class LocationInputView: InputView {

    weak var accommodationsViewControllerDelegate: LocationPopoverViewControllerDelegate?
    weak var popoverViewControllerDelegate: LocationPopoverDelegate?
    private var isPopoverOpen = false
    private var textRestore: String = ""

    override func commonInit() {
        super.commonInit()
        inputPlaceholder = "BUCHAREST"
        labelText = "LOCATION"
        autocapitalizationType = .allCharacters
        delegate = self
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }

    @objc
    func editingChanged(_ textField: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(delayRequest), object: nil)
        if textField.text!.count >= 3 {
            perform(#selector(delayRequest), with: nil, afterDelay: 0.2)
        }
    }

    @objc func delayRequest() {
        guard let text = textField.text else {
            print("Something went wrong when attempting to access text field text.")
            return
        }
        getData(keyword: text)
    }

    func getData(keyword: String) {
        LocationService.searchLocation(keyword: keyword) { [weak self] result in
            guard let strongSelf = self else {
                print("Cannot access instance of LocationinputView class.")
                return
            }
            switch result {
            case let .success(locations):
                let suggestions = locations.filter { $0.type == "CITY" }.map { $0.suggestionModel }
                if suggestions.count > 0 {
                    // UI updates must be performed on main thread
                    // Performed synchronously because controller is needed for next instruction
                    if !(strongSelf.isPopoverOpen) {
                        DispatchQueue.main.sync {
                            strongSelf.accommodationsViewControllerDelegate?.openPopover()
                        }
                    }
                    strongSelf.popoverViewControllerDelegate?.fetch(data: suggestions)
                    strongSelf.isPopoverOpen = true
                } else {
                    if strongSelf.isPopoverOpen {
                        DispatchQueue.main.sync {
                            strongSelf.popoverViewControllerDelegate?.dismissPopover()
                        }
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        textRestore = text
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textRestore
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Modifying the textfield before using its content
        let oldString = textField.text ?? ""
        guard let replacementRange = Range(range, in: oldString) else {
            print("Something went wrong when attempting to create replacement string range.")
            return false
        }
        textField.text = oldString.replacingCharacters(in: replacementRange, with: string).uppercased()
        guard let text = textField.text else {
            print("Something went wrong when attempting to access text field text.")
            return false
        }
        let lengthOfText = text.count
        if lengthOfText < 3 && isPopoverOpen {
            popoverViewControllerDelegate?.dismissPopover()
            isPopoverOpen = false
        }
        textField.sendActions(for: .editingChanged)
        // Always returns false since textfield is already modified
        return false
    }
}

extension LocationInputView: SuggestionViewControllerDelegate {
    func didSelect(model: SuggestionTableViewCellModel) {
        self.endEditing(true)
        self.inputText = model.title
        if let modelId = model.id {
            accommodationsViewControllerDelegate?.setLocationId(modelId)
        }
        accommodationsViewControllerDelegate?.setLocation(model.title)
        isPopoverOpen = !isPopoverOpen
    }
}
