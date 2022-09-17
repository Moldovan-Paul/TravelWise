import Foundation
import UIKit
import SwiftyJSON

enum SearchForFlightType {
    case departureFlight
    case returnFlight
}

class FlightService {
    private var componentURL: URLComponents
    private var headers: KeyValuePairs<String, String>
    private var parameters: KeyValuePairs<String, String>

    public var currentPage: Int = 1
    public var isPaginating: Bool = false

    init() {
        componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "priceline-com-provider.p.rapidapi.com"
        componentURL.path = "/v2/flight"

        headers = ["X-RapidAPI-Key": "176a80a9c7msh37e3397eaee0e13p12851bjsn3876039b9449",
                   "X-RapidAPI-Host": "priceline-com-provider.p.rapidapi.com"]

        parameters = ["sortBy": "AirportName:asc",
                      "sid": "iSiX639"]

    }

    private func composeUserParameters(searchParameters: FlightsSearchParams, forFlight flightType: SearchForFlightType) -> KeyValuePairs<String, String>? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var departureDate: String
        var originAirportCode: String
        var destinationAirportCode: String
        let adults = "\(searchParameters.numberOfPassengers)"

        switch flightType {
        case .departureFlight:
            departureDate = dateFormatter.string(from: searchParameters.departureDate)
            originAirportCode = searchParameters.departureAirportCode
            destinationAirportCode = searchParameters.arrivalAirportCode
        case .returnFlight:
            guard let returnDepartureDate = searchParameters.returnDepartureDate else {
                return nil
            }
            departureDate = dateFormatter.string(from: returnDepartureDate)
            originAirportCode = searchParameters.arrivalAirportCode
            destinationAirportCode = searchParameters.departureAirportCode

        }

        return [
            "departure_date": departureDate,
            "origin_airport_code": originAirportCode,
            "destination_airport_code": destinationAirportCode,
            "adults": adults
        ]
    }

    func processJSON(data: Data) -> [OneFlightEntity]? {
        do {
            let itineraryData = try JSON(data: data)["getAirFlightDepartures"]["results"]["result"]["itinerary_data"]
            let page = try JSON(data: data)["getAirFlightDepartures"]["results"]["result"]["page_number"].intValue
            let arrayItinerary = itineraryData.map { $0.1 }

            let flights: [OneFlightEntity] = arrayItinerary.map { itinerary in

                let slice = itinerary["slice_data"].map { $0.1 }[0]

                return OneFlightEntity(companyImage: slice["airline"]["logo"].string,
                                       companyName: slice["airline"]["name"].string,
                                       departureTime: slice["departure"]["datetime"]["time_24h"].string,
                                       arrivalTime: slice["arrival"]["datetime"]["time_24h"].string,
                                       layoverTime: nil,
                                       numberOfStops: slice["info"]["connection_count"].intValue,
                                       duration: slice["info"]["duration"].string,
                                       price: itinerary["price_details"]["baseline_total_fare"].floatValue)

            }
            currentPage = page + 1
            return flights

        } catch {
            print(error)
            return nil
        }
    }

    private func createURLRequest(searchParameters: FlightsSearchParams, forFlight: SearchForFlightType) -> URLRequest? {
        var urlComponents = componentURL
        urlComponents.path += "/departures"
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let userParameters = composeUserParameters(searchParameters: searchParameters, forFlight: forFlight) else {
            print("Round trip requested but returnDepartureDate is nil")
            return nil
        }

        userParameters.forEach { (key, value) in
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        switch searchParameters.returnDepartureDate == nil {
        case true:
            urlComponents.queryItems?.append(URLQueryItem(name: "results_per_page", value: "10"))
        case false:
            // if is a round trip, there are 3 departure flights and 3 return flights; 3*3 = 9 itineraries
            urlComponents.queryItems?.append(URLQueryItem(name: "results_per_page", value: "3"))

        }

        urlComponents.queryItems?.append(URLQueryItem(name: "page", value: "\(currentPage)"))

        guard let requestURL = urlComponents.url else {
            return nil
        }

        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"

        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }

    func searchFlights(searchParameters: FlightsSearchParams, completion: @escaping (Result<[FlightEntity], Error>) -> Void) {

        isPaginating = true

        guard let departureRequestURL = createURLRequest(searchParameters: searchParameters, forFlight: .departureFlight) else {
            print("Unable to create URL from users' keyword")
            return
        }

        switch searchParameters.itineraryType {
        case .oneWay:
            searchForOneWayTrip(url: departureRequestURL, completion: completion)
        case .roundTrip:
            guard let returnRequestURL = createURLRequest(searchParameters: searchParameters, forFlight: .returnFlight) else {
                print("Unable to create URL from users' keyword for return flight")
                return
            }
            searchForRoundTrip(departureURL: departureRequestURL, returnURL: returnRequestURL, completion: completion)
        }
    }

    private func searchForOneWayTrip(url requestURL: URLRequest, completion: @escaping (Result<[FlightEntity], Error>) -> Void) {

        URLSession.shared.dataTask(with: requestURL) {(data, response, error) in

            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")
            }

            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let departureFlights = self.processJSON(data: validData)
                guard let departureFlights = departureFlights else {
                    print("No departure flights found")
                    return
                }

                let departureFlightEntities: [FlightEntity] = departureFlights.map({ flight in
                    return FlightEntity(departureFlight: flight)
                }).sorted { entity1, entity2 in
                    return entity1.departureFlight.price ?? 0 < entity2.departureFlight.price ?? 0
                }
                completion(.success(departureFlightEntities))
            }
            self.isPaginating = false
        }.resume()
    }

    private func searchForRoundTrip(departureURL: URLRequest, returnURL: URLRequest, completion: @escaping (Result<[FlightEntity], Error>) -> Void) {
        var departureFlights: [OneFlightEntity] = []
        var returnFlights: [OneFlightEntity] = []
        let urlDownloadQueue = DispatchQueue(label: "com.flightsSearch.queue")
        let urlDownloadGroup = DispatchGroup()

        // departure request
        urlDownloadGroup.enter()

        URLSession.shared.dataTask(with: departureURL) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API status for departure flight request: \(httpResponse.statusCode)")
            }

            guard let validData = data, error == nil else {
                urlDownloadQueue.async {
                    urlDownloadGroup.leave()
                }

                completion(.failure(error!))
                return
            }

            let requestDepartureFlights = self.processJSON(data: validData) ?? []

            urlDownloadQueue.async {
                departureFlights.append(contentsOf: requestDepartureFlights)
                urlDownloadGroup.leave()
            }
        }.resume()
        // end departure request

        // return flight request
        urlDownloadGroup.enter()

        URLSession.shared.dataTask(with: returnURL) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("API status for return flight request: \(httpResponse.statusCode)")
            }

            guard let validData = data, error == nil else {
                urlDownloadQueue.async {
                    urlDownloadGroup.leave()
                }

                completion(.failure(error!))
                return
            }

            let requestDepartureFlights = self.processJSON(data: validData) ?? []

            urlDownloadQueue.async {
                returnFlights.append(contentsOf: requestDepartureFlights)
                urlDownloadGroup.leave()
            }
        }.resume()
        // end return flight request

        urlDownloadGroup.notify(queue: DispatchQueue.global()) {
            var entities: [FlightEntity] = []

            departureFlights.forEach { departureFlight in
                returnFlights.forEach { returnFlight in
                    entities.append(FlightEntity(departureFlight: departureFlight, returnFlight: returnFlight))
                }
            }

            let sortedEntities = self.sortEntities(entities)

            completion(.success(sortedEntities))
            self.isPaginating = false
        }
    }

    private func sortEntities(_ entities: [FlightEntity]) -> [FlightEntity] {
        return entities.sorted { entity1, entity2 in
            var entity1Price: Float = entity1.departureFlight.price ?? 0
            if let returnFlight1 = entity1.returnFlight {
                entity1Price += returnFlight1.price ?? 0
            }

            var entity2Price: Float = entity2.departureFlight.price ?? 0
            if let returnFlight2 = entity2.returnFlight {
                entity2Price += returnFlight2.price ?? 0
            }
            return entity1Price < entity2Price
        }
    }

}
