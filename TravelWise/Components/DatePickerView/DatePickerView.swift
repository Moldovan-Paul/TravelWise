import UIKit

class DatePickerView: CustomView {

    @IBOutlet private weak var firstUIDatePicker: UIDatePicker!
    @IBOutlet private weak var secondUIDatePicker: UIDatePicker!
    @IBOutlet private weak var firstLabel: UILabel!
    @IBOutlet private weak var secondLabel: UILabel!
    @IBOutlet private weak var separatingLine: UIView!

    var firstDate: Date {
        return firstUIDatePicker.date
    }

    var secondDate: Date {
        return secondUIDatePicker.date
    }

    var isSecondDateSelectable: Bool = true {
        didSet {
            guard isSecondDateSelectable != oldValue else {
                return
            }

            secondUIDatePicker.isUserInteractionEnabled = isSecondDateSelectable
            _ = [secondUIDatePicker, separatingLine, secondLabel].map { $0?.isHidden = !isSecondDateSelectable }
        }
    }

    override func commonInit() {
        super.commonInit()
        firstUIDatePicker.minimumDate = Date()
        secondUIDatePicker.minimumDate = Date()
        firstUIDatePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }

    @IBInspectable var firstLabelText: String = "" {
        didSet {
            self.firstLabel.text = firstLabelText
        }
    }

    @IBInspectable var secondLabelText: String = "" {
        didSet {
            self.secondLabel.text = secondLabelText
        }
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        if sender == firstUIDatePicker {
            secondUIDatePicker.minimumDate = firstUIDatePicker.date
        }

        if !isSecondDateSelectable {
            secondUIDatePicker.date = firstUIDatePicker.date
        }
    }

}
