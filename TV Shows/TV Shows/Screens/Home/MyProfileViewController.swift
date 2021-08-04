//
//  MyProfileViewController.swift
//  TV Shows
//
//  Created by Infinum on 04.08.2021..
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet private weak var myProfilePhotoImageView: UIImageView!
    @IBOutlet private weak var myEmailLabel: UILabel!
    @IBOutlet private weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureUI()
   
        // Do any additional setup after loading the view.
    }
    
}

private extension MyProfileViewController {
    @IBAction func changeProfilePhotoButtonActionHandler() {
    }
    @IBAction func logOutButtonActionHandler() {
    }
}

private extension MyProfileViewController {
    func configureUI() {
        logOutButton.makeRounded(withCornerRadius: 20)
        myProfilePhotoImageView.makeRounded(withCornerRadius: 20)
    }
}
