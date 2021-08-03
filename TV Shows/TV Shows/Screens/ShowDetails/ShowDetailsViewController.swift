//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit
import Alamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var show: Show?
    var reviewsResponse: ReviewsResponse?
    var reviews: [Review] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var showDetailsTableView: UITableView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        guard let show = show else { return }
        getReviewsFromApi(for: show.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - IBActions

extension ShowDetailsViewController {
    @IBAction func writeReviewButtonActionHandler() {
        navigateToWriteReview()
    }
}

// MARK: TABLE VIEW
// MARK: - TableView Delegate
extension ShowDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 600 }
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - TableView Datasource
extension ShowDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let show = show else { return UITableViewCell() }
        if indexPath.row == 0 {
            
            let firstCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailFirstTableViewCell.self), for: indexPath) as! ShowDetailFirstTableViewCell
            firstCell.configure(with: show)
            return firstCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailOthersTableViewCell.self), for: indexPath) as! ShowDetailOthersTableViewCell
            otherCell.configure(with: reviews[indexPath.row - 1] )
            return otherCell
        }
    }
}

// MARK: - WriteReviewViewControllerDelegate

extension ShowDetailsViewController : WriteReviewViewControllerDelegate {
    func newCommentAdded() {
        guard let show = show else { return }
        getReviewsFromApi(for: show.id)
        showDetailsTableView.reloadData()
    }
}

// MARK: - Private functions
private extension ShowDetailsViewController {
    func configureUI() {
        writeReviewButton.makeRounded(withCornerRadius: 20)
    }
    
    func getReviewsFromApi(for id: String) {
        SVProgressHUD.show()
        
        APIManager.shared.call(of: ReviewsResponse.self,
                               router: Router.Review.getReviews(id: id)) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let reviewsResponse):
                SVProgressHUD.showSuccess(withStatus: "Success")
                self.reviews = reviewsResponse.reviews
                self.showDetailsTableView.reloadData()
            case .failure(let error):
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func navigateToWriteReview() {
        let storyboard = UIStoryboard(name: "WriteReview", bundle: nil)
        let writeReviewViewController = storyboard
            .instantiateViewController(
                withIdentifier: String(describing: WriteReviewViewController.self)
            ) as! WriteReviewViewController
        writeReviewViewController.show = show
        writeReviewViewController.delegate = self
        navigationController?.present(writeReviewViewController, animated: true, completion: nil)
    }
}
