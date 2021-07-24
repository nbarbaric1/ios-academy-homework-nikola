//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 12.07.2021..
//

// MARK: Imports

import UIKit

class LoginViewController : UIViewController{
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var rememberCheckButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var seePasswordButton: UIButton!
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
}

// MARK: - Extensions

    // MARK: - Utility

private extension LoginViewController{
    
    func configureUI() {
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        passwordTextfield.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        loginButton.layer.cornerRadius = 21.5
        loginButton.clipsToBounds = true
    }
}

    // MARK: - IBActions

private extension LoginViewController{
    
    @IBAction func rememberCheckButtonActionHandler() {
        rememberCheckButton.isSelected.toggle()
    }
    
    @IBAction func emailTextfieldEditingDidEndActionHandler() {
        guard let input: String = emailTextfield.text else { return }
        if input.isValidEmail() {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
            loginButton.setTitleColor(.myPurple, for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .white.withAlphaComponent(0.3)
            loginButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
        }
    }
    
    @IBAction func seePasswordButtonActionHandler() {
        seePasswordButton.isSelected.toggle()
        passwordTextfield.isSecureTextEntry.toggle()
    }
}
