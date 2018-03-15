//
//  EditProfileVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-03-07.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import FirebaseAuth

class EditProfileVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileVC.handleSelectProfileImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if let profileImg = selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            StorageService.instance.uploadProfileImage(uid: (Auth.auth().currentUser?.uid)!, data: imageData)
            dismiss(animated: true, completion: nil)
        }
       
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
