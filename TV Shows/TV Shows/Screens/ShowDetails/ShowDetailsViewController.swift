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
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    var reviewsResponse: ReviewsResponse?
    var reviews: [Review]?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var showDetailsTableView: UITableView!
    @IBOutlet private weak var writeReviewButton: UIButton!

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getReviewsFromApi(for: show!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI()
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
}
// MARK: - TableView Datasource
extension ShowDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show?.numberOfReviews ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let show = show else { return UITableViewCell() }
        guard let reviews = reviews else { return UITableViewCell()}
        if indexPath.row == 0 {
            
            let firstCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailFirstTableViewCell.self), for: indexPath) as! ShowDetailFirstTableViewCell
            firstCell.configure(with: show)
            return firstCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailOthersTableViewCell.self), for: indexPath) as! ShowDetailOthersTableViewCell
            otherCell.configure(with: reviews[indexPath.row] )
            return otherCell
        }
    }
    
    
}
// MARK: - Private functions
private extension ShowDetailsViewController {
    func configureUI() {
        navigationController?.isNavigationBarHidden = false
        writeReviewButton.makeRounded(withCornerRadius: 20)
    }
    
    func getReviewsFromApi(for id: String) {
        SVProgressHUD.show()
        guard let userResponse = userResponse,
              let authInfo = authInfo
        else { //alertError();
            return }
        
        print("AUTHINFO: \(authInfo)")
        
        var reviewsUrl: String = "https://tv-shows.infinum.academy/shows/"
        reviewsUrl.append(id)
        reviewsUrl.append("/reviews")
            
        AF
            .request(
                reviewsUrl,
                method: .get,
                parameters: ["page": "1", "items": "100"], // pagination arguments
                headers: HTTPHeaders(authInfo.headers)
            )
            .validate()
            .responseDecodable(of: ReviewsResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                
                case .success(let reviewsResponse):
                    print("SUCCES in SDVC: \(reviewsResponse)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.reviews = reviewsResponse.reviews
                    self.showDetailsTableView.reloadData()
                case .failure(let error):
                    print("error in SDVC: \(error)")
                    SVProgressHUD.dismiss()
                    //self.alertError()
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
        writeReviewViewController.authInfo = authInfo
        writeReviewViewController.userResponse = userResponse
        navigationController?.present(writeReviewViewController, animated: true, completion: nil)
    }
}
