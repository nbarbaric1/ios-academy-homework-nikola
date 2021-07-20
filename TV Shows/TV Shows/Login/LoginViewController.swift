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
    
    
    
    //MARK: - Properties
    
    
    
    //MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Actions
    
   
    
    
    //MARK: - Private functions
    
    private func configureUI(){
        
        
    }
    
    private func delay(for delay: Double, handler: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            handler()
        }
    }
}
