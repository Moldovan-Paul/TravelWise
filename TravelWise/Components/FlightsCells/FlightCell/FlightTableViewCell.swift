import UIKit

class FlightTableViewCell: UITableViewCell {
    @IBOutlet private weak var topFlightTicketView: FlightTicketView!
    @IBOutlet private weak var bottomFlightTicketView: FlightTicketView!
    @IBOutlet private weak var flightPrice: UILabel!

    private func computePrice(flightEntity: FlightEntity) -> Float {

        let departurePrice = flightEntity.departureFlight.price ?? 0
        guard let returnFlight = flightEntity.returnFlight else {
            return departurePrice.rounded()
        }
        let returnPrice = returnFlight.price ?? 0
        return (departurePrice + returnPrice).rounded()
    }

    func setupWith(flightEntity: FlightEntity) {
        let initialFlight = flightEntity.departureFlight
        topFlightTicketView.setUp(withFlight: initialFlight)

        if let returnFlight = flightEntity.returnFlight {
            bottomFlightTicketView.setUp(withFlight: returnFlight)
        } else {
            bottomFlightTicketView.isHidden = true
        }

        let price = computePrice(flightEntity: flightEntity)
        flightPrice.text = "$\(Int(floor(price)))"

    }

}
