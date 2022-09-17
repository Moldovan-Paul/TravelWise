import UIKit

class ImageCache {
    static let sharedImageCache = ImageCache()
    var imageUrlDictionary: [String: UIImage] = [:]
    func clearImageCache() {
        imageUrlDictionary = [:]
    }
}
