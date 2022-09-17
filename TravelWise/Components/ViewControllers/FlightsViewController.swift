import Foundation
import UIKit
import SwiftyJSON

final class FlightsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var datePickerView: DatePickerView!
    @IBOutlet weak var endpointsView: EndpointsView!
    @IBOutlet weak var oneWayButton: ToggleButton!
    @IBOutlet weak var personInputView: PersonInputView!

    private var searchParameters: FlightsSearchParams? {
        let itineraryType: ItineraryType = oneWayButton.isChecked ? .oneWay : .roundTrip
        let departureDate = datePickerView.firstDate
        let returnDate = oneWayButton.isChecked ? nil : datePickerView.secondDate
        guard let departureAirportName = endpointsView.departureAirportName, departureAirportName != "",
              let departureAirportCode = endpointsView.departureAirportCode, departureAirportCode != "",
              let arrivalAirportName = endpointsView.arrivalAirportName, arrivalAirportName != "",
              let arrivalAirportCode = endpointsView.arrivalAirportCode, arrivalAirportCode != "" else {
            return nil
        }

        return FlightsSearchParams(itineraryType: itineraryType,
                                   departureAirportName: departureAirportName,
                                   departureAirportCode: departureAirportCode,
                                   arrivalAirportName: arrivalAirportName,
                                   arrivalAirportCode: arrivalAirportCode,
                                   departureDate: departureDate,
                                   numberOfPassengers: personInputView.adultCount,
                                   returnDepartureDate: returnDate)
    }

    // MARK: - Lifecycle
    @IBAction func oneWayDidChange(_ sender: ToggleButton) {
        datePickerView.isSecondDateSelectable = !sender.isChecked
    }

    @IBAction func searchPressed(_ sender: Any) {
        guard searchParameters != nil else {
            // show warning with ok sign
            let alert = UIAlertController(title: "", message: FlightsAlert.title.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: FlightsAlert.action.rawValue.uppercased(), style: .default))
            self.present(alert, animated: true)
            return
        }
        performSegue(withIdentifier: FlightsSegueIdentifiers.flightResults.rawValue, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        endpointsView.viewControllerDelegate = self
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FlightsSegueIdentifiers.airportSuggestions.rawValue {
            guard let popoverViewController = segue.destination as? AirportSuggestionViewController else {
                print("PopoverViewController is not of type SuggestionViewController")
                return
            }
            popoverViewController.modalPresentationStyle = .popover

            guard let presentationController = popoverViewController.popoverPresentationController else {
                print("PopoverViewController presentationController is nil")
                return
            }

            presentationController.delegate = self
            popoverViewController.delegate = endpointsView
            endpointsView.searchSuggestionDelegate = popoverViewController
        }

        if segue.identifier == FlightsSegueIdentifiers.flightResults.rawValue {
            guard let destination = segue.destination as? FlightResultsViewController else {
                print("Destination to segue \"FlightResults\" is not of type FlightResultsViewController")
                return
            }
            destination.searchParameters = searchParameters
        }
    }
}

extension FlightsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension FlightsViewController: EndpointsViewControllerDelegate {
    func shouldOpenSuggestions() {
        DispatchQueue.main.sync { [weak self] in
            // if popup is presented
            guard !(self?.presentedViewController is AirportSuggestionViewController) else {
                return
            }
            self?.performSegue(withIdentifier: FlightsSegueIdentifiers.airportSuggestions.rawValue, sender: self)
        }
    }

    func shouldCloseSuggestions() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
