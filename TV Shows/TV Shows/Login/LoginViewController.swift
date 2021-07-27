//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 12.07.2021..
//

// MARK: Imports

import UIKit
import Alamofire
import SVProgressHUD

class LoginViewController : UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var rememberCheckButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var seePasswordButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - Properties
    
    var userResponse: UserResponse?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        configureUI()
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
    }
}

// MARK: IBActions

private extension LoginViewController{
    @IBAction private func rememberCheckButtonActionHandler() {
        rememberCheckButton.isSelected.toggle()
    }
    @IBAction private func passwordEditingDidEndActionHandler() {
        checkInputs()
    }
    
    @IBAction private func emailTextfieldEditingDidEndActionHandler() {
        checkInputs()
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
        let params : [String: String] = [
            "email" : email,
            "password" : password,
            "password_confirmation" : password
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result{
                case .success(let user):
                    self.userResponse = user
                    print(self.userResponse)
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self.navigateToHomeScreen()
                case .failure(let error):
                    print("error: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    @IBAction private func loginButtonActionHandler(){
        
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text
        else {return}
        
        SVProgressHUD.show()
        let params : [String: String] = [
            "email" : email,
            "password" : password,
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                
                case .success(let user):
                    print("succes: \(user.user.email)")
                    let headers = response.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: user.user, headers: headers)
                    self.navigateToHomeScreen()
                case .failure(let error):
                    print("error: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
}

// MARK: - Private functions

private extension LoginViewController {
    private func navigateToHomeScreen(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "Success")
    }
    
    private func checkInputs() {
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text
        else { return }
        
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
}
