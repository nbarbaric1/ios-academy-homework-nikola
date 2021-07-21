//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 12.07.2021..
//

// MARK: Imports

import Foundation
import UIKit
import SVProgressHUD

class LoginViewController : UIViewController{
    
    //MARK: - Outlets
    
    @IBOutlet private weak var changeStateButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    private var numberOfTaps: Int = 0
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Actions
    
    @IBAction func changeStateButtonActionHandler() {
        print("button tapped")
        numberOfTaps += 1
        textLabel.text = "Tapped \(numberOfTaps) times"
        
        if indicatorView.isAnimating{
            indicatorView.stopAnimating()
            changeStateButton.setTitle("Start", for: .normal)
        } else {
            indicatorView.startAnimating()
            changeStateButton.setTitle("Stop", for: .normal)
        }
    }
    
    //MARK: - Private functions
    
    private func configureUI(){
        changeStateButton.layer.cornerRadius = 25
        changeStateButton.clipsToBounds = true
        indicatorView.hidesWhenStopped = true
        
        showIndicatorView(forSeconds: 3)
    }
    
    private func showIndicatorView(forSeconds: Int){
        indicatorView.startAnimating()
        delay(for: 3.0){
            self.indicatorView.stopAnimating()
        }
    }
    
    private func delay(for delay: Double, handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            handler()
        }
    }
}
