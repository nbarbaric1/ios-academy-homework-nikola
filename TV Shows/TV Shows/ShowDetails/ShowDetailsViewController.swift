//
//  ShowDetailsViewController.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    var show: Show?
    
    @IBOutlet private weak var showDetailsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI()
    }
}

extension ShowDetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 600 }
        return 140
    }
}

extension ShowDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show?.numberOfReviews ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let show = show else { return UITableViewCell() }
        if indexPath.row == 0 {
            
            let firstCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailFirstTableViewCell.self), for: indexPath) as! ShowDetailFirstTableViewCell
            firstCell.configure(with: show)
            return firstCell
        } else {
            let otherCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowDetailOthersTableViewCell.self), for: indexPath) as! ShowDetailOthersTableViewCell
            otherCell.configure(with: show)
            return otherCell
        }
    }
    
    
}

private extension ShowDetailsViewController {
    func configureUI() {
        navigationController?.isNavigationBarHidden = false
    }
}
