//
//  MyProfileViewController.swift
//  TV Shows
//
//  Created by Infinum on 04.08.2021..
//

import UIKit
import SVProgressHUD
import Alamofire

class MyProfileViewController: UIViewController {
    
    @IBOutlet private weak var myProfilePhotoImageView: UIImageView!
    @IBOutlet private weak var myEmailLabel: UILabel!
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var transparentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    
    var user: User?
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        configureUI()
        getMyProfileDataFromApi()
        imagePicker.delegate = self
    }
    
}

private extension MyProfileViewController {
    @IBAction func changeProfilePhotoButtonActionHandler() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonActionHandler() {
        dismiss(animated: true, completion: nil)
        UDM.shared.defaults.removeObject(forKey: Constants.Storage.authInfoUserDefaultsKey)
        AuthStorage.shared.authInfo = nil
        let notification = Notification(name: Notification.Name(Constants.Notifications.logOut))
        NotificationCenter.default.post(notification)
        
    }
}

private extension MyProfileViewController {
    func configureUI() {
        logOutButton.makeRounded(withCornerRadius: 20)
        myProfilePhotoImageView.makeRounded(withCornerRadius: 75)
        containerView.makeRounded(withCornerRadius: 20)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        transparentView.addGestureRecognizer(tapGesture)
    }
    
    func getMyProfileDataFromApi() {
        SVProgressHUD.show()
        APIManager.shared.call(of: UserResponse.self,
                               router: Router.MyProfile.getInfo()){ [weak self] result in
            guard let self = self else { return }
            switch (result) {
            
            case .success(let userResponse):
                self.user = userResponse.user
                self.setProfileData()
                SVProgressHUD.showSuccess(withStatus: "Loaded")
            case .failure(_):
                print("error")
                SVProgressHUD.showError(withStatus: "Error")
            }
        }
    }
    
    func setProfileData() {
        guard let user = user else { return }
        myEmailLabel.text = user.email
        
        if let image = user.imageUrl {
            myProfilePhotoImageView.kf.setImage(with: URL(string: image), placeholder: UIImage(named: "ic-profile-placeholder"))
        } else {
            myProfilePhotoImageView.image = UIImage(named: "ic-profile-placeholder")
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension MyProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myProfilePhotoImageView.contentMode = .scaleAspectFill
            uploadProfilePhoto(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilePhoto(image: UIImage){
        
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {return}
        
        let requestData = MultipartFormData()
        
        requestData.append(imageData,
                           withName: "image",
                           fileName: "image.jpg",
                           mimeType: "image/jpg")
        
        
//        AF
//            .upload(
//                multipartFormData: requestData,
//                to: "https://tv-shows.infinum.academy/users",
//                method: .put
//            )
//            .validate()
//            .responseDecodable(of: UserResponse.self){ result in
//                switch (result.result) {
//
//                case .success(let userResponse):
//                    self.user = userResponse.user
//                    self.setProfileData()
//                case .failure(let error):
//                    print("error mora biti: ", error)
//                }
//            }
        
        
        
        
        
    }
}

