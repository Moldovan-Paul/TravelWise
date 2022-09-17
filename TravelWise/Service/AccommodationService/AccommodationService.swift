import Foundation
import UIKit

class AccommodationService {

    static var lock = NSLock()
    var firstRequestWasMade = false
    var noMoreData = false
    var isPaginating = false

    private func createURLRequest(data: AccommodationsRequestParameters) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "hotels4.p.rapidapi.com"
        components.path = "/properties/list"
        components.queryItems = [URLQueryItem(name: "destinationId", value: data.destinationId),
                                 URLQueryItem(name: "pageNumber", value: String(data.pageNumber)),
                                 URLQueryItem(name: "pageSize", value: "10"),
                                 URLQueryItem(name: "checkIn", value: data.checkIn),
                                 URLQueryItem(name: "checkOut", value: data.checkOut),
                                 URLQueryItem(name: "starRatings", value: data.minStarRating),
                                 URLQueryItem(name: "adults1", value: data.adultCount),
                                 URLQueryItem(name: "sortOrder", value: data.sortOrder),
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

    func searchLocation(data: AccommodationsRequestParameters, completion: @escaping (Result<[AccommodationEntity], Error>) -> Void) {
        self.isPaginating = true
        guard let requestURL = createURLRequest(data: data) else {
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
                let accommodationResponse = try JSONDecoder().decode(AccommodationResponse.self, from: validData)
                if accommodationResponse.result == "ERROR" {
                    completion(.success([]))
                } else {
                    if let accommodationResponseData = accommodationResponse.data {
                        if accommodationResponseData.body.searchResults.pagination.currentPage == 1 && self.firstRequestWasMade {
                            self.noMoreData = true
                            completion(.success([]))
                        } else {
                            self.firstRequestWasMade = true
                            completion(.success((accommodationResponseData.body.searchResults.results)))
                        }
                    } else {
                        print("Response returned no results")
                        completion(.success([]))
                    }
                }
            } catch let serializationError {
                completion(.failure(serializationError))
            }
            self.isPaginating = false
        }.resume()
    }

    static func loadImageFrom(url: String, completion: @escaping (UIImage?) -> Void) {
        if let hotelLogoURL = URL(string: url) {
            let session = URLSession(configuration: .default)
            let downloadPicTask = session.dataTask(with: hotelLogoURL) { (data, response, error) in
                if let err = error {
                    print("Error downloading hotel logo: \(err)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded hotel logo with response code \(res.statusCode)")
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            // Dictionaries are not thread safe so we use a mutex
                            AccommodationService.lock.lock()
                            ImageCache.sharedImageCache.imageUrlDictionary[url] = image
                                completion(image)
                            AccommodationService.lock.unlock()
                        } else {
                            print("Couldn't get image: Image is nil")
                            completion(nil)
                        }
                    } else {
                        print("Couldn't get response code")
                        completion(nil)
                    }
                }
            }
            downloadPicTask.resume()
        } else {
            print("Could not convert string to URL")
            completion(nil)
        }
    }
}
