import Foundation
import UIKit

final class AccommodationsViewController: UIViewController {
    @IBOutlet private weak var locationInputView: LocationInputView!
    @IBOutlet private weak var starRatingView: StarRatingView!
    @IBOutlet private weak var datePickerView: DatePickerView!
    @IBOutlet private weak var personInputView: PersonInputView!
    @IBOutlet private weak var searchButton: SearchButton!

    private var location: String = ""
    private var locationId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Tap on screen will dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        searchButton.buttonColor = UIColor(named: "greenColor")!

        datePickerView.firstLabelText = "CHECK IN"
        datePickerView.secondLabelText = "CHECK OUT"
        personInputView.personLabel = "GUESTS"

        locationInputView.accommodationsViewControllerDelegate = self

    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let identifierCase = AccommodationsSegueIdentifiers(rawValue: identifier) else {
            print("Could not map segue identifier to a segue case")
            return
        }
        switch identifierCase {
        case .secondSuggestionSegue:
            guard let popoverViewController = segue.destination as? AccommodationSuggestionViewController else {
                print("PopoverViewController is not of type SuggestionViewController")
                return
            }
            popoverViewController.modalPresentationStyle = .popover
            guard let popoverPresentationController = popoverViewController.popoverPresentationController else {
                return
            }
            popoverPresentationController.delegate = self
            popoverViewController.delegate = locationInputView
            locationInputView.popoverViewControllerDelegate = popoverViewController
        case .accommodationsNavigationSegue:
            guard let searchResultsViewController = segue.destination as? AccommodationSearchResultsViewController else {
                print("View Controller is not of type AccommodationSearchResultsViewController")
                return
            }
            searchResultsViewController.locationId = self.locationId
            searchResultsViewController.accommodationFilterModel = AccommodationFilterEntity(location: self.location,
                                                                                             checkInDate: datePickerView.firstDate,
                                                                                             checkOutDate: datePickerView.secondDate,
                                                                                             minStarRating: starRatingView.starCount,
                                                                                             adultCount: personInputView.adultCount)
        default:
            return
        }
    }

    @IBAction func performNavigationSegue(_ sender: Any) {
        if location.isEmpty {
            let alert = UIAlertController(title: "", message: AccommodationStrings.selectLocation.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: AccommodationStrings.okay.description.uppercased(), style: .default))
            self.present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: AccommodationsSegueIdentifiers.accommodationsNavigationSegue.rawValue, sender: self)
    }
}

extension AccommodationsViewController: LocationPopoverViewControllerDelegate {
    func openPopover() {
        performSegue(withIdentifier: AccommodationsSegueIdentifiers.secondSuggestionSegue.rawValue, sender: self)
    }

    func setLocationId(_ locationId: String) {
        self.locationId = locationId
    }

    func setLocation(_ location: String) {
        self.location = location
    }
}

extension AccommodationsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
