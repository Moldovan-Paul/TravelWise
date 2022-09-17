import UIKit

class CustomControl: UIControl {
    @IBOutlet private weak var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let className = String(describing: nibNameFor(type(of: self))).components(separatedBy: ".").last ?? ""
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        contentView.fixInView(self)

        clipsToBounds = true
        applyCornerRadius()
    }

    private func nibNameFor(_ theClass: AnyClass) -> String {
        let className = String(describing: theClass).components(separatedBy: ".").last ?? ""
        guard Bundle.main.path(forResource: className, ofType: "nib") != nil else {
            guard let superClass = theClass.superclass() else {
                fatalError("Xib doesn't exist")
            }
            return nibNameFor(superClass)
        }
        return className
    }
}
