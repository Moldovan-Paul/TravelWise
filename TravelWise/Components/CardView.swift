import UIKit

/// Basic card with changeable properties
@IBDesignable
class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
  }

    @IBInspectable var shadowHeight: Float {
        get {
            return Float(layer.shadowOffset.height)
        }
        set {
            let width = layer.shadowOffset.width
            let CGNewHeight = CGFloat(newValue)
            layer.shadowOffset = CGSize(width: width, height: CGNewHeight)
        }
    }

    @IBInspectable var shadowWidth: Float {
        get {
            return Float(layer.shadowOffset.height)
        }
        set {
            let height = layer.shadowOffset.height
            let CGNewWidth = CGFloat(newValue)
            layer.shadowOffset = CGSize(width: CGNewWidth, height: height)
        }
    }

    @IBInspectable var shadowColor: UIColor {
        get {
            guard let color = layer.shadowColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            switch newValue {
            case _ where newValue <= 0:
                layer.shadowOpacity = 0
            case _ where newValue >= 1:
                layer.shadowOpacity = 1
            default:
                layer.shadowOpacity = newValue
            }
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
      get {
          return self.layer.shadowRadius
      }
      set {
          self.layer.shadowRadius = newValue
      }
  }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaults()
    }

    private func setupDefaults() {
        self.shadowHeight = 1
        self.shadowWidth = 2
        self.shadowRadius = 2
        self.shadowColor = .darkGray
        self.shadowOpacity = 0.4
        self.cornerRadius = 14
    }

}
