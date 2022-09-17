import UIKit

class HelperClass {

    public static func setStarRating(stars: Int, stackView: UIStackView) {
        for (index, star) in stackView.arrangedSubviews.enumerated() {
            if index >= stars {
                star.tintColor = .clear
            } else {
                star.tintColor = UIColor(named: "greenColor")
            }
        }
    }

    public static func getOrder(_ orderParameter: String) -> String {
        switch orderParameter {
        case "BEST SELLER":
            return "BEST_SELLER"
        case "PRICE (ASCENDING)":
            return "PRICE"
        case "PRICE (DESCENDING)":
            return "PRICE_HIGHEST_FIRST"
        case "STAR RATING (HIGHEST FIRST)":
            return "STAR_RATING_HIGHEST_FIRST"
        case "STAR RATING (LOWEST FIRST)":
            return "STAR_RATING_LOWEST_FIRST"
        default:
            return "BEST_SELLER"
        }
    }
}
