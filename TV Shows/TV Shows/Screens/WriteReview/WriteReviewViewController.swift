//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

protocol WriteReviewViewControllerDelegate : AnyObject {
    func newCommentAdded()
}

class WriteReviewViewController: UIViewController {
    
    // MARK: - Properties
    
    var show: Show?
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    var notificationTokens: [NSObjectProtocol] = []
    weak var delegate: WriteReviewViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var commentTextView: UITextView!
    @IBOutlet private weak var submitButton: UIButton!
    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        scrollView.deleteObservers(for: notificationTokens)
    }
}

// MARK: IBActions
extension WriteReviewViewController {
    @IBAction func submitButtonActionHandler() {
        guard let show = show,
              let authInfo = authInfo
        else { return }
        SVProgressHUD.show()
        let params : [String: String] = [
            "rating" : String(ratingView.rating),
            "comment" : commentTextView.text,
            "show_id" : show.id
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/reviews",
                method: .post,
                parameters: params,
                headers: HTTPHeaders(authInfo.headers))
            .validate()
            .responseDecodable(of: WriteReviewResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let writeReviewResponse):
                    print("success WRVC")
                    self.delegate?.newCommentAdded()
                    SVProgressHUD.showSuccess(withStatus: "Commented")
                case .failure(let error):
                    print("error WRVC: \(error)")
                    SVProgressHUD.dismiss()
                }
            }
    }
}
// TODO: Check this
extension WriteReviewViewController : RatingViewDelegate {
    func didChangeRating(_ rating: Int) { // TODO: check
        checkInputs()
    }
}

// MARK: UITextView Delegate
extension WriteReviewViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkInputs()
    }
}

// MARK: - Private functions

private extension WriteReviewViewController {
    func configureUI() {
        notificationTokens = scrollView.handleKeyboard()
        self.hideKeyboardWhenTappedAround()
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
