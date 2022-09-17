import Foundation

class AccommodationSuggestionViewController: SuggestionViewController, LocationPopoverDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func dismissPopover() {
        dismiss(animated: true)
    }

    func fetch(data: [SuggestionTableViewCellModel]) {
        self.data = data
    }
}
