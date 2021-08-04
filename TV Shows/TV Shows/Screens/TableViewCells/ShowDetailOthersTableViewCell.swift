//
//  ShowDetailOthersTableViewCell.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Kingfisher

class ShowDetailOthersTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var emailOfReviewerLabel: UILabel!
    @IBOutlet private weak var photoOfReviewerImageView: UIImageView!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        photoOfReviewerImageView.layer.cornerRadius = 20
        photoOfReviewerImageView.clipsToBounds = true
        photoOfReviewerImageView.image = UIImage(named: "ic-profile-placeholder")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = ""
        emailOfReviewerLabel.text = ""
        photoOfReviewerImageView.image = UIImage(named: "ic-profile-placeholder")
    }

    func configure(with review: Review) {
        commentLabel.text = review.comment
        emailOfReviewerLabel.text = review.user.email
        ratingView.configure(withStyle: .small)
        ratingView.isEnabled = false
        ratingView.setRoundedRating(Double(review.rating))
        
        if let image = review.user.imageUrl {
            photoOfReviewerImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "ic-profile-placeholder"))
        } else {
            photoOfReviewerImageView.image = UIImage(named: "ic-profile-placeholder")
        }
    }
}
