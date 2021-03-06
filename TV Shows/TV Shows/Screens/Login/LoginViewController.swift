//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 12.07.2021..
//

// MARK: Imports

import UIKit
import SVProgressHUD

class LoginViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var rememberCheckButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var seePasswordButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    var notificationTokens: [NSObjectProtocol] = []
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    deinit {
        notificationTokens.forEach { notificationToken in
            scrollView.deleteObservers(for: notificationToken)
        }
    }
}

// MARK: - Extensions

// MARK: Utility

private extension LoginViewController {
    func configureUI() {
        emailTextfield.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        passwordTextfield.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        loginButton.layer.cornerRadius = 22
        loginButton.clipsToBounds = true
        notificationTokens = scrollView.handleKeyboard()
    }
}

// MARK: IBActions

private extension LoginViewController {
    @IBAction private func rememberCheckButtonActionHandler() {
        rememberCheckButton.isSelected.toggle()
    }
    @IBAction private func passwordEditingDidChangeActionHandler() {
        checkInputs(didEnd: false)
    }
    
    @IBAction private func emailTextfieldEditingDidChangeActionHandler() {
        checkInputs(didEnd: false)
    }
    
    @IBAction private func passwordEditingDidEndActionHandler() {
        checkInputs(didEnd: true)
    }
    
    @IBAction private func emailTextfieldEditingDidEndActionHandler() {
        checkInputs(didEnd: true)
    }
    
    @IBAction private func seePasswordButtonActionHandler() {
        seePasswordButton.isSelected.toggle()
        passwordTextfield.isSecureTextEntry.toggle()
    }
    
    @IBAction private func registerButtonActionHandler() {
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text
        else {return}
        
        SVProgressHUD.show()
        
        let router = Router.User.register(email: email, password: password)
        performAuth(with: router)
    }
    
    @IBAction private func loginButtonActionHandler(){
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text
        else {return}
        
        let router = Router.User.login(email: email, password: password)
        performAuth(with: router)
    }
}

// MARK: - Private functions

private extension LoginViewController {
    func performAuth(with router: Router){
        let rememberMe = rememberCheckButton.isSelected
        SVProgressHUD.show()
        
        APIManager.shared.call(of: UserResponse.self, router: router) { dataResponse in
            let authInfo = dataResponse
                .response
                .map(\.headers)
                .map(\.dictionary)
                .flatMap { try? AuthInfo(headers: $0) }
            
            if rememberMe {
                AuthStorage.shared.storeAuthInfo(authInfo)
            } else {
                AuthStorage.shared.authInfo = authInfo
            }
        } completion: { [weak self] result in
            guard let self = self else { return }
            switch result{
            
            case .success(_):
                SVProgressHUD.showSuccess(withStatus: "Logged-in")
                self.navigateToHomeScreen()
            case .failure(let error):
                print("error: \(error)")
                SVProgressHUD.showError(withStatus: "Error")
            }
        }
    }
    
    func navigateToHomeScreen() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    func checkInputs(didEnd: Bool) {
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text
        else { return }
        
        if didEnd && !email.isValidEmail(){
            emailTextfield.shake()
        }
        if didEnd && !(password.count > 5) {
            passwordTextfield.shake()
        }
        
        if email.isValidEmail() && password.count > 5{
            loginButton.isEnabled = true
            loginButton.backgroundColor = .white
            loginButton.setTitleColor(.myPurple, for: .normal)
            registerButton.isEnabled = true
            registerButton.setTitleColor(.white, for: .normal)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .white.withAlphaComponent(0.3)
            loginButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
            registerButton.isEnabled = false
            registerButton.setTitleColor(.white.withAlphaComponent(0.3), for: .normal)
        }
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "An error occurred. Please check your inputs and try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}

