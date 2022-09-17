import Foundation
import UIKit

struct FlightEntity {
    var departureFlight: OneFlightEntity
    var returnFlight: OneFlightEntity?
}

struct OneFlightEntity {
    var companyImage: String?
    var companyName: String?
    var departureTime: String?
    var arrivalTime: String?
    var layoverTime: String?
    var numberOfStops: Int?
    var duration: String?
    var price: Float?
}

struct FlightResponse: Decodable {
    var id: String
}
