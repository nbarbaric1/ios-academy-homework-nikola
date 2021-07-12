//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 12.07.2021..
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    @IBOutlet weak var tapMeButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    var numOfTaps = 0
    var indicatorOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapMeButton.layer.cornerRadius = 25
        tapMeButton.clipsToBounds = true
        
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.indicatorView.stopAnimating()
        }
        
        
    }
    
    @IBAction func buttonActionHandler(_ sender: Any) {
        print("button tapped")
        numOfTaps += 1
        textLabel.text = "Tapped \(numOfTaps) times"
        
        if indicatorOn == false{
            indicatorView.startAnimating()
            indicatorOn = true
        }
        else {
            indicatorView.stopAnimating()
            indicatorOn = false
        }
    }
    
    
    
    
    
}
