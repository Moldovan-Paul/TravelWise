import Foundation

public enum AccommodationStrings {

    case location
    case checkIn
    case checkOut
    case selectLocation
    case okay

    public var description: String {
        switch self {
        case .location:
            return "Location"
        case .checkIn:
            return "Check in"
        case .checkOut:
            return "Check out"
        case .selectLocation:
            return "Please select a location."
        case .okay:
            return "Ok"
        }
    }
}
