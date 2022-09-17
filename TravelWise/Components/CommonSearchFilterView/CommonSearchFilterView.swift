import UIKit

class CommonSearchFilterView: CustomView {

    @IBOutlet private weak var firstLocationHelperLabel: UILabel!
    @IBOutlet private weak var firstLocationLabel: UILabel!
    @IBOutlet private weak var firstDateHelperLabel: UILabel!
    @IBOutlet private weak var firstDateLabel: UILabel!
    @IBOutlet private weak var secondDateHelperLabel: UILabel!
    @IBOutlet private weak var secondDateLabel: UILabel!
    @IBOutlet private weak var adultCountLabel: UILabel!
    @IBOutlet private weak var flightDestinationLabel: UILabel!
    @IBOutlet private weak var starRatingStackView: UIStackView!
    @IBOutlet private weak var flightsView: UIView!
    @IBOutlet private weak var accommodationsView: UIView!
    @IBOutlet private weak var adultCountImageView: UIImageView!

    // Enums and variables for setting helper labels and colors
    enum FirstLocationType: String {
        case accommodationsType, flightsType

        var rawValue: String {
                switch self {
                case .accommodationsType:
                    return AccommodationStrings.location.description.uppercased()
                case .flightsType:
                    return FlightStrings.from.description.uppercased()
                }
        }
    }

    enum FirstDateType: String {
        case accommodationsType, flightsType

        var rawValue: String {
                switch self {
                case .accommodationsType:
                    return AccommodationStrings.checkIn.description.uppercased()
                case .flightsType:
                    return FlightStrings.departure.description.uppercased()
                }
        }
    }

    enum SecondDateType: String {
        case accommodationsType, flightsType

        var rawValue: String {
                switch self {
                case .accommodationsType:
                    return AccommodationStrings.checkOut.description.uppercased()
                case .flightsType:
                    return FlightStrings.return.description.uppercased()
                }
        }
    }

    enum ScreenType: String {
        case accommodationsType, flightsType
    }

    var firstLocationType: FirstLocationType! {
        didSet {
            firstLocationHelperLabel.text = firstLocationType.rawValue
        }
    }

    var isSecondDateHidden: Bool = false {
        didSet {
            secondDateLabel.isHidden = isSecondDateHidden
            secondDateHelperLabel.isHidden = isSecondDateHidden
        }
    }

    func setScreenType(type: ScreenType) {
        switch type {
        case .accommodationsType:
            flightsView.isHidden = true
            accommodationsView.isHidden = false
        case .flightsType:
            accommodationsView.isHidden = true
            flightsView.isHidden = false
        }
    }

    var firstDateType: FirstDateType! {
        didSet {
            firstDateHelperLabel.text = firstDateType.rawValue
        }
    }

    var secondDateType: SecondDateType! {
        didSet {
            secondDateHelperLabel.text = secondDateType.rawValue
        }
    }

    var adultBgColor: UIColor! {
        didSet {
            adultCountImageView.tintColor = adultBgColor
        }
    }

    func setStarRating(stars: Int) {
        guard flightsView.isHidden == true else {
            return
        }
        HelperClass.setStarRating(stars: stars, stackView: starRatingStackView)
    }

    // Variables for setting data
    var firstLocation: String! {
        didSet {
            firstLocationLabel.text = firstLocation
        }
    }

    var firstDate: String! {
        didSet {
            firstDateLabel.text = firstDate
        }
    }

    var secondDate: String! {
        didSet {
            secondDateLabel.text = secondDate
        }
    }

    var flightDestinationLocation: String! {
        didSet {
            flightDestinationLabel.text = flightDestinationLocation
        }
    }

    var adultCount: Int! {
        didSet {
            adultCountLabel.text = "\(adultCount ?? 0)"
        }
    }

    func setUpViewFor(type: ScreenType) {
        setScreenType(type: type)
        switch type {
        case .flightsType:
            firstLocationType = .flightsType
            firstDateType = .flightsType
            secondDateType = .flightsType
        case .accommodationsType:
            firstLocationType = .accommodationsType
            firstDateType = .accommodationsType
            secondDateType = .accommodationsType
        }
    }
}
