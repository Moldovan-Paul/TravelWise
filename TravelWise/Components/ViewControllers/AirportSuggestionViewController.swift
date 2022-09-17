import UIKit

class AirportSuggestionViewController: SuggestionViewController {
    private var allAirportsFound: [SuggestionTableViewCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension AirportSuggestionViewController: EndpointsSearchSuggestionDelegate {
    func didUpdateSuggestions(suggestions: [SuggestionTableViewCellModel]) {
        data = suggestions
    }

    func didAcceptFirstSuggestion() {
        if !data.isEmpty {// accept first result if there is one
            delegate?.didSelect(model: data[0])
        }

        dismiss(animated: true)
    }
}
