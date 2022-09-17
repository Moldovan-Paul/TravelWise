import UIKit

struct AccommodationEntity: Decodable {
    var name: String?
    var optimizedThumbUrls: ImageURL?
    var starRating: Float?
    var address: Address?
    var roomsLeft: Int?
    var ratePlan: Price?

    func getAccommodationName() -> String {
        return name ?? "Unknown name"
    }

    func getAccommodationAdress() -> String {
        return address?.streetAddress ?? "Unknwon address"
    }

    func getAccommodationRoomsLeft() -> String {
        if let roomsLeft = roomsLeft {
            return "Rooms left: \(roomsLeft)"
        }
        return "Rooms left: unknown"
    }

    func getAccommodationPrice() -> String {
        if let priceWithComma = ratePlan?.price?.current {
            return priceWithComma.components(separatedBy: ",").joined()
        }
        return "$???"
    }
}

struct AccommodationResponse: Decodable {
    var result: String
    var data: HotelData?
}

struct HotelData: Decodable {
    var body: Body
}

struct Body: Decodable {
    var searchResults: SearchResults
}

struct SearchResults: Decodable {
    var results: [AccommodationEntity]
    var pagination: PaginationInfo
}

struct Address: Decodable {
    var streetAddress: String?
}

struct Price: Decodable {
    var price: CurrentPrice?
}

struct CurrentPrice: Decodable {
    var current: String?
}

struct ImageURL: Decodable {
    var srpDesktop: String?
}

struct PaginationInfo: Decodable {
    var currentPage: Int?
}
