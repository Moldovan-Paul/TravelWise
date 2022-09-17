import UIKit

class SearchButton: CustomControl {
    @IBOutlet weak var button: UIButton!

    @IBAction func didTouch(_ sender: Any) {
        sendActions(for: .touchUpInside)
    }
    @IBInspectable
    public var buttonColor: UIColor = .tintColor {
        didSet {
            button.tintColor = buttonColor
        }
    }

    @IBInspectable
    public var buttonTitle: String = "Search" {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    override func commonInit() {
        super.commonInit()
        applyCornerRadius(radius: 10)
        button.setTitle(buttonTitle, for: .normal) // if buttonTitle was not changed from XIB, didSet will not trigger, thus making the title "Button"; use buttonTitle as init value
    }
}
