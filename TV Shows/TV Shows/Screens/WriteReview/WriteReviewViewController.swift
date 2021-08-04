//
//  WriteReviewViewController.swift
//  TV Shows
//
//  Created by Infinum on 29.07.2021..
//

import UIKit
import SVProgressHUD

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
        notificationTokens.forEach { notificationToken in
            scrollView.deleteObservers(for: notificationToken)
        }    }
}

// MARK: IBActions
extension WriteReviewViewController {
    @IBAction func submitButtonActionHandler() {
        guard let show = show else { return }
        SVProgressHUD.show()
     
        APIManager.shared.call(of: WriteReviewResponse.self,
                               router: Router.Review.addReview(rating: String(ratingView.rating),
                                                               comment: commentTextView.text,
                                                               id: show.id))
            { [weak self] result in
                guard let self = self else {return}
                
                switch result {
                case .success(_):
                    self.delegate?.newCommentAdded()
                    SVProgressHUD.showSuccess(withStatus: "Commented")
                case .failure(_):
                    SVProgressHUD.showError(withStatus: "Error")
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
