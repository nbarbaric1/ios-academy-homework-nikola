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

    // MARK: - Utility

private extension LoginViewController{
    

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
    @IBAction private func passwordEditingDidEndActionHandler() {
        checkInputs()
    }
    
    @IBAction private func emailTextfieldEditingDidEndActionHandler() {
        checkInputs()
    }
    
    @IBAction private func seePasswordButtonActionHandler() {
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
    
    @IBAction private func registerButtonActionHandler() {
        
        SVProgressHUD.show()
        let params : [String: String] = [
            "email" : emailTextfield.text!, //je li okej force unwrap ako sam ranije osigurao da se ne moze kliknuti ako nema unosa
            "password" : passwordTextfield.text!,
            "password_confirmation" : passwordTextfield.text!
        ]
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserResponse.self) { [weak self] response in
                
                switch response.result{
                    case .success(let user):
                        self?.userResponse = user
                        print(self?.userResponse)
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        self?.navigateToHomeScreen()
                    case .failure(let error):
                        print("error: \(error)")
                        SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    @IBAction private func loginButtonActionHandler(){
        
        SVProgressHUD.show()
        let params : [String: String] = [
            "email" : emailTextfield.text!,
            "password" : passwordTextfield.text!,
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
                
                switch response.result{
                
                    case .success(let user):
                        print("succes: \(user.user.email)")
                        let headers = response.response?.headers.dictionary ?? [:]
                        self?.handleSuccesfulLogin(for: user.user, headers: headers)
                        self?.navigateToHomeScreen()
                    case .failure(let error):
                        print("error: \(error)")
                        SVProgressHUD.showError(withStatus: "Failure")
                }
            }
    }
    
    //MARK: - Private functions
    
    private func navigateToHomeScreen(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "Home_ViewController") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: "Missing headers")
            return
        }
        SVProgressHUD.showSuccess(withStatus: "Success")
    }
    
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

    
    private func checkInputs(){
        if let email = emailTextfield.text,
           let password = passwordTextfield.text{
            
            if isValidEmail(email) && password.count > 5{
                loginButton.isEnabled = true
                loginButton.backgroundColor = .white
                loginButton.setTitleColor(.myPurple, for: .normal)
                registerButton.isEnabled = true
                registerButton.setTitleColor(.white, for: .normal)
            } else{
                loginButton.isEnabled = false
                loginButton.backgroundColor = .white.withAlphaComponent(0.3)
                loginButton.setTitleColor(.white.withAlphaComponent(0.4), for: .normal)
                registerButton.isEnabled = false
                registerButton.setTitleColor(.white.withAlphaComponent(0.3), for: .normal)
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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
