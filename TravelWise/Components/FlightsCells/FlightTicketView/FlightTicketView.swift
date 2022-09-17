import UIKit

class FlightTicketView: CustomView {
    @IBOutlet private weak var companyPhotoImageView: UIImageView!
    @IBOutlet private weak var companyNameLabel: UILabel!
    @IBOutlet private weak var departureTimeLabel: UILabel!
    @IBOutlet private weak var arrivalTimeLabel: UILabel!
    @IBOutlet private weak var layoverTimeLabel: UILabel!
    @IBOutlet private weak var numberOfStopsStackView: UIStackView!
    @IBOutlet private weak var numberOfStopsLabel: UILabel!

    func setUp(withFlight flight: OneFlightEntity) {
        companyPhoto = flight.companyImage ?? "questionmark"
        companyName = flight.companyName ?? "Unknown Company"
        departureTime = flight.departureTime ?? "??:??"
        arrivalTime = flight.arrivalTime ?? "??:??"
        layoverTime = "????"
        if let durationPieces = flight.duration?.split(separator: ":"), durationPieces.count == 3 {
            var duration: String = ""
            if Int(durationPieces[0]) ?? 0 > 0 {
                duration += "\(Int(durationPieces[0]) ?? 0) days "
            }
            if Int(durationPieces[1]) ?? 0 > 0 {
                duration += "\(Int(durationPieces[1]) ?? 0) hrs "
            }
            if Int(durationPieces[2]) ?? 0 > 0 {
                duration += "\(Int(durationPieces[2]) ?? 0) mins"
            }
            layoverTime = duration
        }

        numberOfStops = flight.numberOfStops ?? 0
    }

    public var companyPhoto: String = "" {
        didSet {
            do {
                AccommodationService.loadImageFrom(url: companyPhoto) { image in
                    if image != nil {
                        DispatchQueue.main.async { [weak self] in
                            self?.companyPhotoImageView.image = image
                        }
                    }
                }
            }
        }
    }

    public var companyName: String = "" {
        didSet {
            companyNameLabel.text = companyName
        }
    }

    public var departureTime: String = "" {
        didSet {
            departureTimeLabel.text = departureTime
        }
    }

    public var arrivalTime: String = "" {
        didSet {
            arrivalTimeLabel.text = arrivalTime
        }
    }

    public var layoverTime: String = "" {
        didSet {
            layoverTimeLabel.text = layoverTime
        }
    }

    public var numberOfStops: Int = 0 {
        didSet {
            numberOfStopsLabel.text = "stops: \(numberOfStops)"

            if oldValue == 0 && numberOfStops != 0 {
                numberOfStopsStackView.isHidden = false
                return
            }

            if numberOfStops == 0 {
                numberOfStopsStackView.isHidden = true
                return
            }
        }
    }

    override func commonInit() {
        super.commonInit()
        applyCornerRadius(radius: 0)
    }

}
