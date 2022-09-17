import Foundation

class AirportService {
    private var componentURL: URLComponents
    private var headers: KeyValuePairs<String, String>
    private var parameters: KeyValuePairs<String, String>

    private func createURLRequest(keyword: String) -> URLRequest? {
        var urlComponents = componentURL
        urlComponents.path += "/" + keyword

        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems

        guard let requestURL = urlComponents.url else {
            return nil
        }

        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = "GET"

        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }

    /// GET Request for finding the desired airport
    ///
    /// - parameter keyword: Can be a part of: City Name, Airport Name, Airport Code, City Code
    func searchAirports(keyword: String, completion: @escaping (Result<[AirportEntity], Error>) -> Void) {
        guard let requestURL = createURLRequest(keyword: keyword) else {
            print("Unable to create URL from users' keyword")
            return
        }

        URLSession.shared.dataTask(with: requestURL ) { (data, response, error) in

            if let httpResponse = response as? HTTPURLResponse {
                print("API status: \(httpResponse.statusCode)")
            }

            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }

            do {
              let airportResponse = try JSONDecoder().decode(AirportResponse.self, from: validData)
                completion(.success(airportResponse.results))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
    }

    init() {
        componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "world-airports-directory.p.rapidapi.com"
        componentURL.path = "/v1/airports"

        headers = KeyValuePairs<String, String>()
        headers = ["X-RapidAPI-Key": "176a80a9c7msh37e3397eaee0e13p12851bjsn3876039b9449",
                                        "X-RapidAPI-Host": "world-airports-directory.p.rapidapi.com"]

        parameters = KeyValuePairs()
        parameters = ["page": "1",
                      "limit": "20",
                      "sortBy": "AirportName:asc"]

    }
}
