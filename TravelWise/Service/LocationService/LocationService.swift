import Foundation

class LocationService {
    private static func createURLRequest(keyword: String) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hotels4.p.rapidapi.com"
        components.path = "/locations/v2/search"
        components.queryItems = [URLQueryItem(name: "query", value: keyword),
                                 URLQueryItem(name: "locale", value: "en_US"),
                                 URLQueryItem(name: "currency", value: "USD")]
        guard let url = components.url else {
            print("Failed to create url")
            return nil
        }
        var URLrequest = URLRequest(url: url)
        URLrequest.httpMethod = "GET"
        URLrequest.allHTTPHeaderFields = ["X-RapidAPI-Key": "176a80a9c7msh37e3397eaee0e13p12851bjsn3876039b9449",
                                          "X-RapidAPI-Host": "hotels4.p.rapidapi.com"]
        return URLrequest
    }

    static func searchLocation(keyword: String, completion: @escaping (Result<[LocationEntity], Error>) -> Void) {
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
                let accommodationResponse = try JSONDecoder().decode(LocationResponse.self, from: validData)
                completion(.success(accommodationResponse.suggestions[0].entities))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
    }
}
