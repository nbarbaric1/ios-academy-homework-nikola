//
//  ShowDetailFirstTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class ShowDetailFirstTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var showImageView: UIImageView!
    @IBOutlet private weak var showDescriptionLabel: UILabel!
    @IBOutlet private weak var showRating: RatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showDescriptionLabel.text = ""
    }

    func configure(with show: Show) {
        showImageView.kf.setImage(with: URL(string: show.imageUrl),
                                  placeholder: UIImage(named: "ic-show-placeholder-vertical"))
        showDescriptionLabel.text = show.description
        
        if let averageRating = show.averageRating {
            showRating.isHidden = false
            showRating.configure(withStyle: .large)
            showRating.isEnabled = false
            showRating.setRoundedRating(Double(averageRating))
        } else {
            showRating.isHidden = true
        }
    }
}
