//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class WriteReviewViewController: UIViewController {
    
    var show: Show?
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension WriteReviewViewController {
    @IBAction func submitButtonActionHandler() {
        guard let show = show else { return }
        SVProgressHUD.show()
        let params : [String: String] = [
            "comment" : commentTextView.text,
            "rating" : String(ratingView.rating),
            "show_id" : show.id
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let reviewResponse):
                    print("success WRVC")
                    SVProgressHUD.showSuccess(withStatus: "yes")
                case .failure(let error):
                    print("error WRVC: \(error)")
                    SVProgressHUD.dismiss()
                }
            }
    }
}

extension WriteReviewViewController : RatingViewDelegate {
    func didChangeRating(_ rating: Int) { // TODO: check
        checkInputs()
    }
}

extension WriteReviewViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkInputs()
    }
}

private extension WriteReviewViewController {
    func configureUI() {
        commentTextView.makeRounded(withCornerRadius: 20)
        submitButton.makeRounded(withCornerRadius: 20)
        
        //TODO: Check
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
          )
    }
    
    @objc func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func checkInputs() {
        commentTextView.text.count < 15 || ratingView.rating < 1
            ? submitButton.disableButton()
            : submitButton.enableButton()
    }
}
