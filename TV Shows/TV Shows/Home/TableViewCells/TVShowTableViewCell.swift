//
//  TVShowTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class TVShowTableViewCell: UITableViewCell {
    
    @IBOutlet private var showNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        showNameLabel.textColor = .red
    }
    
    func configure(with showName: String){
        showNameLabel.text = showName
    }
}
