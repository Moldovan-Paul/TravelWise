import UIKit

class SuggestionTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UITextField!
    @IBOutlet private weak var secondaryTitleLabel: UILabel!
    @IBOutlet private weak var optionalTextLabel: UILabel!

    func setupWithModel(model: SuggestionTableViewCellModel) {
        titleLabel.text = model.title
        secondaryTitleLabel.text = model.secondaryTitle
        optionalTextLabel.text = model.optionalText
    }

}
