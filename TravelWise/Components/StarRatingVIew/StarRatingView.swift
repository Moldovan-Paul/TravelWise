import UIKit

class StarRatingView: CustomView {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var star1: UIButton!
    @IBOutlet private weak var star2: UIButton!
    @IBOutlet private weak var star3: UIButton!
    @IBOutlet private weak var star4: UIButton!
    @IBOutlet private weak var star5: UIButton!
    @IBOutlet private weak var stackView: UIStackView!

    private(set) var starCount: Int = 3

    override func commonInit() {
        super.commonInit()
        colorStarsBackground()
    }

    @IBAction func oneStar() {
        changeStarCount(stars: 1)
    }

    @IBAction func twoStars() {
        changeStarCount(stars: 2)
    }

    @IBAction func threeStars() {
        changeStarCount(stars: 3)
    }

    @IBAction func fourStars() {
        changeStarCount(stars: 4)
    }

    @IBAction func fiveStars() {
        changeStarCount(stars: 5)
    }

    private func changeStarCount(stars: Int) {
        starCount = stars
        colorStarsBackground()
    }

    private func colorStarsBackground() {
        for case let (index, button) as (Int, UIButton) in stackView.arrangedSubviews.enumerated() {
            if index < starCount {
                button.tintColor = UIColor(named: "greenColor")
            } else {
                button.tintColor = UIColor(named: "grayStar")
            }
        }
    }

}
