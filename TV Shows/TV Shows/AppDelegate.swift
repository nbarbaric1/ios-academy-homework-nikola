//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Infinum on 08.07.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        let authInfo: AuthInfo? = AuthStorage.shared.authInfo
        
        if authInfo != nil {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            navigationController.pushViewController(homeViewController, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController.pushViewController(loginViewController, animated: true)
        }
        return true
    }
    
    
    
}

