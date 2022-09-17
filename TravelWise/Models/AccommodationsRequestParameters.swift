import Foundation

struct AccommodationsRequestParameters {
    var destinationId: String
    var pageNumber: Int
    var checkIn: String
    var checkOut: String
    var minStarRating: String
    var adultCount: String
    var sortOrder: String

    func createStarCountString(stars: Int) -> String {
        switch stars {
        case 1:
            return "1,2,3,4,5"
        case 2:
            return "2,3,4,5"
        case 3:
            return "3,4,5"
        case 4:
            return "4,5"
        case 5:
            return "5"
        default:
            return "1,2,3,4,5"
        }
    }
}
