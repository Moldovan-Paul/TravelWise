import UIKit
protocol EndpointsViewControllerDelegate: AnyObject {
    func shouldOpenSuggestions()
    func shouldCloseSuggestions()
}

protocol EndpointsSearchSuggestionDelegate: AnyObject {
    func didUpdateSuggestions(suggestions: [SuggestionTableViewCellModel])
    func didAcceptFirstSuggestion()
}

class EndpointsView: CustomView, UITextFieldDelegate {
    @IBOutlet private weak var fromAirportCodeLabel: UILabel!
    @IBOutlet private weak var toAirportCodeLabel: UILabel!
    @IBOutlet private weak var fromInputView: InputView!
    @IBOutlet private weak var toInputView: InputView!
    private weak var selectedInputView: InputView?
    private var suggestions: [SuggestionTableViewCellModel] = [] {// all fetched data
        didSet {
            if suggestions.isEmpty {
                viewControllerDelegate?.shouldCloseSuggestions()
            } else {
                viewControllerDelegate?.shouldOpenSuggestions()
            }

            searchSuggestionDelegate?.didUpdateSuggestions(suggestions: suggestions)
        }
    }

    weak var viewControllerDelegate: EndpointsViewControllerDelegate?
    weak var searchSuggestionDelegate: EndpointsSearchSuggestionDelegate?
    var departureAirportCode: String? {
        return fromAirportCodeLabel.text
    }
    var arrivalAirportCode: String? {
        return toAirportCodeLabel.text
    }
    var departureAirportName: String? {
        return fromInputView.inputText
    }
    var arrivalAirportName: String? {
        return toInputView.inputText
    }

    override func commonInit() {
        super.commonInit()

        fromInputView.textField.autocapitalizationType = .allCharacters
        toInputView.textField.autocapitalizationType = .allCharacters
        fromInputView.textField.delegate = self
        toInputView.textField.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // select all text if user wants to write something else
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)

        switch textField {
        case fromInputView.textField:
            selectedInputView = fromInputView
        case toInputView.textField:
            selectedInputView = toInputView
        default:
            fatalError("EndpointsView delegate triggered from an unknown textfield")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchForSuggestions(sender:)),
            object: textField)
        perform(#selector(searchForSuggestions), with: textField, afterDelay: 0.2)

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchSuggestionDelegate?.didAcceptFirstSuggestion()
        endEditing(true)
        return true
    }

    @objc
    func searchForSuggestions(sender: Any) {
        guard let textField = sender as? UITextField,
              let keyword = textField.text else {
            print("searchForSuggestions sender does not have a valid keyword or it's not a TextField")
            return
        }

        guard keyword.count >= 3 else {
            suggestions.removeAll()
            return
        }

        let airportService = AirportService()
        airportService.searchAirports(keyword: keyword) { [weak self] result in
            switch result {
            case let .success(airports):
                var suggestions: [SuggestionTableViewCellModel] = []
                airports.forEach { entity in
                    let newSuggestion = entity.suggestionModel
                    suggestions.append(newSuggestion)
                }
                self?.suggestions = suggestions

            case let .failure(error):
                print(error)
            }
        }
    }
}

extension EndpointsView: SuggestionViewControllerDelegate {
    func didSelect(model: SuggestionTableViewCellModel) {
        endEditing(true)
        switch selectedInputView {
        case toInputView:
            toInputView.inputText = model.title
            toAirportCodeLabel.text = model.optionalText
        case fromInputView:
            fromInputView.inputText = model.title
            fromAirportCodeLabel.text = model.optionalText
        default:
            fatalError("EndpointsView didSelect triggered from an unknown textfield")
        }
    }
}
