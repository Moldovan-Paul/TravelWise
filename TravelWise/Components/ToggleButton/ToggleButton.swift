import UIKit

class ToggleButton: UIButton {
    @IBInspectable
    public var isChecked: Bool = false {
        didSet {
            if oldValue == isChecked {
                return
            }
            sendActions(for: .valueChanged)
        }
    }

    @IBInspectable
    public var textColorOff: UIColor = UIColor(named: "grayUnselectedText") ?? .clear

    @IBInspectable
    public var textColorOn: UIColor = .white

    @IBInspectable
    public var colorOff: UIColor = UIColor(named: "grayUnselectedBackground") ?? .clear

    @IBInspectable
    public var colorOn: UIColor = .tintColor

    override func updateConfiguration() {
        guard let configuration = configuration else {
                    return
                }
                var updatedConfiguration = configuration

                var background = UIButton.Configuration.plain().background

                background.cornerRadius = 10
                background.strokeWidth = 1

                let strokeColor: UIColor
                let foregroundColor: UIColor
                let backgroundColor: UIColor = isChecked ? colorOn : colorOff
                let baseColor = updatedConfiguration.baseForegroundColor ?? UIColor.tintColor

           switch self.state {
           case .normal:
               strokeColor = .clear
               foregroundColor = isChecked ? textColorOn : textColorOff
           case [.highlighted]:
               strokeColor = baseColor.darkerTone().withAlphaComponent(0.3)
               foregroundColor = isChecked ? textColorOn : textColorOff
           default:
               strokeColor = .clear
               foregroundColor = baseColor
           }

           background.strokeColor = strokeColor
           background.backgroundColor = backgroundColor

           updatedConfiguration.baseForegroundColor = foregroundColor
           updatedConfiguration.background = background

           self.configuration = updatedConfiguration
       }

    @objc
    private func touchUpInside() {
        isChecked = !isChecked
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        updateConfiguration()
        setNeedsUpdateConfiguration()
    }
}
