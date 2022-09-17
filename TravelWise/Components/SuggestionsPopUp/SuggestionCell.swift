//
//  SuggestionCell.swift
//  TravelWise
//
//  Created by Bogdan Fomin on 30.08.2022.
//

import UIKit

class SuggestionCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UITextField!
    @IBOutlet private weak var secondaryTitleLabel: UILabel!
    @IBOutlet private weak var optionalTextLabel: UILabel!

    func setupWith(model: SuggestionTableViewCellModel) {
        titleLabel.text = model.title
        secondaryTitleLabel.text = model.secondaryTitle
        optionalTextLabel.text = model.optionalText
    }

}
