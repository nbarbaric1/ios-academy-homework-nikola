//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet private var showNameLabel: UILabel!
    @IBOutlet private var showImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showNameLabel.text = ""
    }
    
    func configure(with show: Show){
        showNameLabel.text = show.title
        showImageView.kf.setImage(with: URL(string: show.imageUrl))
    }
}
