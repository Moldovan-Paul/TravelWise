import Foundation

struct AirportEntity: Decodable {
    var id: String
    var isActive: Bool
    var airportName: String
    var city: String
    var country: String
    var airportCode: String

    var suggestionModel: SuggestionTableViewCellModel {
        return SuggestionTableViewCellModel(title: airportName, secondaryTitle: city + ", " + country, optionalText: airportCode, id: nil)
    }

    enum CodingKeys: String, CodingKey {
        case id, isActive, city, country, airportCode = "AirportCode", airportName = "AirportName"
    }
}

struct AirportResponse: Decodable {
    var results: [AirportEntity]
    var page: Int
    var limit: Int
    var totalPages: Int
    var totalResults: Int
}
