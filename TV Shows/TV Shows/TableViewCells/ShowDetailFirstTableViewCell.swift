//
//  ShowDetailFirstTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class ShowDetailFirstTableViewCell: UITableViewCell {
    
    @IBOutlet private var showImageView: UIImageView!
    @IBOutlet private var showDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showDescriptionLabel.text = ""
    }

    func configure(with show: Show) {
        showImageView.kf.setImage(with: URL(string: show.imageUrl))
        showDescriptionLabel.text = show.description
    }

}
