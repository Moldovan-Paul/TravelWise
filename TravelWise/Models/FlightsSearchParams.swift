import Foundation

enum ItineraryType: String {
   case oneWay = "ONE_WAY"
   case roundTrip = "ROUND_TRIP"
}

struct FlightsSearchParams {
    var itineraryType: ItineraryType
    var departureAirportName: String
    var departureAirportCode: String
    var arrivalAirportName: String
    var arrivalAirportCode: String
    var departureDate: Date
    var numberOfPassengers: Int
    var returnDepartureDate: Date?
}
