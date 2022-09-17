import Foundation

struct LocationEntity: Decodable {
    var city: String
    var type: String
    var country: String
    var locationId: String

    var suggestionModel: SuggestionTableViewCellModel {
        var countryString = country.components(separatedBy: ",")
        // Triming irrelevant information
        for index in countryString.indices {
            countryString[index] = countryString[index].trimmingCharacters(in: .whitespaces)
        }
        countryString = countryString.filter { component in
            return component.contains("<") == false
        }
        if countryString.count >= 3 {
            countryString.remove(at: 0)
        }
        return SuggestionTableViewCellModel(title: city.uppercased(), secondaryTitle: countryString.joined(separator: ", "), optionalText: nil, id: locationId)
    }

    enum CodingKeys: String, CodingKey {
        case city = "name", type, country = "caption", locationId = "destinationId"
    }
}

struct LocationResponse: Decodable {
    var suggestions: [Suggestions]

}

struct Suggestions: Decodable {
    var group: String
    var entities: [LocationEntity]
}
