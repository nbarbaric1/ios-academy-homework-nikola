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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
        )
        navigationController?.isToolbarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(didSelectClose)
        )
        navigationController?.isToolbarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    
    }
    
    deinit {
        notificationTokens.forEach { notificationToken in
            scrollView.deleteObservers(for: notificationToken)
        }
    }
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
                self.dismiss(animated: true)
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
    }
    
    //TODO: Check
    
    func checkInputs() {
        commentTextView.text.count < 15 || ratingView.rating < 1
            ? submitButton.disableButton()
            : submitButton.enableButton()
    }
    
    @objc func didSelectClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

