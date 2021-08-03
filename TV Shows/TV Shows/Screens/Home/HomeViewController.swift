//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 22.07.2021..
//

//MARK: Imports

import UIKit
import Alamofire
import SVProgressHUD

class HomeViewController : UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var showsTableView: UITableView!
    
    // MARK: - Properties
    
    var shows: [Show] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getShowsFromApi()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - TableView
    // MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToDetails(for: shows[indexPath.row])
    }
}
    // MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TVShowTableViewCell.self), for: indexPath) as! TVShowTableViewCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}
    
// MARK: - Private functions

private extension HomeViewController {
    func configureUI() {
        
    }
    
    func navigateToDetails(for show: Show) {
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: nil)
        let showDetailsViewController = storyboard
            .instantiateViewController(
                withIdentifier: String(describing: ShowDetailsViewController.self)
            ) as! ShowDetailsViewController
        showDetailsViewController.show = show
        navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "An error occurred. Please check your connection and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func getShowsFromApi() {
        SVProgressHUD.show()
        
        APIManager.shared.call(of: ShowsResponse.self,
                               router: Router.Show.shows()){ [weak self] result in
            guard let self = self else { return }
            print("result in hvc:", result)
            switch result {
            case .success(let showsResponse):
                print((showsResponse))
                SVProgressHUD.showSuccess(withStatus: "Success")
                self.shows = showsResponse.shows
                self.showsTableView.reloadData()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: "Error")
            }
        }
    }
    
    func setupTableView() {
        showsTableView.estimatedRowHeight = 120
        showsTableView.rowHeight = UITableView.automaticDimension
        showsTableView.delegate = self
        showsTableView.dataSource = self
    }
}
