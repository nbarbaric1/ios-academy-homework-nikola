//
//  HomeViewController.swift
//  TV Shows
//
//  Created by Infinum on 22.07.2021..
//

//MARK: Imports

import UIKit
import Alamofire

class HomeViewController : UIViewController{
    
    
    // MARK: - Properties
    @IBOutlet weak var authInfoa: UILabel!
    @IBOutlet weak var userResponsea: UILabel!
    
    var userResponse: UserResponse?
    var authInfo: AuthInfo?
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("userResponse in HomeVC: \(userResponse)")
        print("Authinfo in HomeVC:  \(authInfo)")
        
        
        AF
        .request(
            "https://tv-shows.infinum.academy/shows",
            method: .get,
            parameters: ["page": "1", "items": "100"], // pagination arguments
            headers: HTTPHeaders(authInfo.headers)
        )
        .validate()
        .responseDecodable(of: ShowsResponse.self) { }
        
    }
    
    
}
