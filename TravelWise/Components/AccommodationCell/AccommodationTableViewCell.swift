import UIKit

class AccommodationTableViewCell: UITableViewCell {

    @IBOutlet private weak var hotelLogoImageView: UIImageView!
    @IBOutlet private weak var starRatingStackView: UIStackView!
    @IBOutlet private weak var accommodationNameLabel: UILabel!
    @IBOutlet private weak var accommodationAdressLabel: UILabel!
    @IBOutlet private weak var roomsLeftLabel: UILabel!
    @IBOutlet private weak var priceTagLabel: UILabel!

    private func setStarRating(stars: Int) {
        for (index, star) in starRatingStackView.arrangedSubviews.enumerated() {
            if index >= stars {
                star.tintColor = .clear
            } else {
                star.tintColor = UIColor(named: "greenColor")
            }
        }
    }

    func setupWithAccommodation(accommodation: AccommodationEntity) {
        accommodationNameLabel.text = accommodation.getAccommodationName()
        accommodationAdressLabel.text = accommodation.getAccommodationAdress()
        roomsLeftLabel.text = accommodation.getAccommodationRoomsLeft()
        priceTagLabel.text = accommodation.getAccommodationPrice()
        if let hotelLogoLink = accommodation.optimizedThumbUrls?.srpDesktop {
            if let cachedImage = ImageCache.sharedImageCache.imageUrlDictionary[hotelLogoLink] {
                DispatchQueue.main.async { [weak self] in
                    self?.hotelLogoImageView.image = cachedImage
                }
            } else {
                AccommodationService.loadImageFrom(url: hotelLogoLink) { image in
                    if image != nil {
                        DispatchQueue.main.async { [weak self] in
                            self?.hotelLogoImageView.image = image
                        }
                    }
                }
            }
        }
        setStarRating(stars: Int(accommodation.starRating ?? 0))
    }

}
