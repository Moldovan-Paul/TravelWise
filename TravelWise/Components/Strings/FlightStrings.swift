import Foundation

public enum FlightStrings {

    case from
    case departure
    case `return`

    public var description: String {
        switch self {
        case .from:
            return "From"
        case .departure:
            return "Departure"
        case .`return`:
            return "Return"
        }
    }
}
