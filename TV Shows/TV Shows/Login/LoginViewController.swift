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
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var rememberCheckButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var seePasswordButton: UIButton!
    //MARK: - Properties
    
    
    //MARK: - Lifecycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    //MARK: - Actions
    
    @IBAction private func rememberCheckButtonActionHandler() {
        if rememberCheckButton.isSelected{
            rememberCheckButton.isSelected = false
            rememberCheckButton.setImage(UIImage(named: "ic-checkbox-unselected"), for: .normal)
        } else{
            rememberCheckButton.isSelected = true
            rememberCheckButton.setImage(UIImage(named: "ic-checkbox-selected"), for: .normal)
        }
        
    }
    
    @IBAction func emailTextfieldEditingDidEndActionHandler() {
        if let input = emailTextfield.text{
            if isValidEmail(input) {
                loginButton.isEnabled = true
                loginButton.backgroundColor = .white
                loginButton.setTitleColor(.myPurple, for: .normal)
            } else{
                loginButton.isEnabled = false
                loginButton.backgroundColor = .white.withAlphaComponent(0.3)
                loginButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
            }
        }
    }
    
    
    @IBAction func seePasswordButtonActionHandler() {
        print("tapped")
        if seePasswordButton.isSelected{
            seePasswordButton.isSelected = false
            seePasswordButton.setImage(UIImage(named: "ic-visible"), for: .normal)
            passwordTextfield.isSecureTextEntry = true
        } else{
            seePasswordButton.isSelected = true
            seePasswordButton.setImage(UIImage(named: "ic-invisible"), for: .normal)
            passwordTextfield.isSecureTextEntry = false
        }
    }
    
    
    //MARK: - Private functions
    
    private func configureUI(){
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        passwordTextfield.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        loginButton.layer.cornerRadius = 21.5
        loginButton.clipsToBounds = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

    //MARK: - Extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
  static let myPurple = #colorLiteral(red: 0.3215686275, green: 0.2117647059, blue: 0.5490196078, alpha: 1)
}
