//
//  SideMenuVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-27.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import SideMenu
import Firebase
import Kingfisher

protocol SideMenuVCDelegate: class {
    func onLogoutPressed()
}

class SideMenuVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var editPasswordBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
        
    weak var delegate: SideMenuVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserImage()
        retrieveDBFullName()
        sideMenuCustomization()
        outletCustomization()
        addTapGestures()
    }
    
    func addTapGestures() {
        let imageTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SideMenuVC.imgAction))
        profileImg.addGestureRecognizer(imageTap)
    }
    
    func retrieveDBFullName() {
        let uid = Auth.auth().currentUser?.uid
        let dataBaseFirstName = DataService.instance.REF_USERS.child(uid!).child("fullname")
        dataBaseFirstName.observe(.value) { (snapshot) in
            
            let firstname = snapshot.value as! String
            self.fullNameLbl.text = firstname.uppercased()
            
        }
    }
    
    func setUserImage() {
        let uid = Auth.auth().currentUser?.uid
        DataService.instance.getUserImage(uid: uid!) { (url) in
            let imageUrl = URL(string: url)
            self.profileImg.kf.setImage(with: imageUrl)
        }
    }
    
    func outletCustomization() {
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        editProfileBtn.adjustsImageWhenHighlighted = false
        editPasswordBtn.adjustsImageWhenHighlighted = false
        logoutBtn.adjustsImageWhenHighlighted = false

    }
    
    func sideMenuCustomization() {
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationFadeStrength = 0.3
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = 275
    }
    
    func createLogoutAlert() {
        let alert = UIAlertController(title: "Are you sure you want to log out of Rival?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let logoutFailure = UIAlertController(title: "Logout failed. Please try again or check your connection", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertActionStyle.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                self.delegate?.onLogoutPressed()
            } catch {
                print(error)
                self.present(logoutFailure, animated: true, completion: nil)
            }
        }))
        
        logoutFailure.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imgAction(){
        print("hello")
        // perform the action here when the image is pressed
    }
   
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC")
        present(editProfileVC!, animated: true, completion: nil)
    }
    
    @IBAction func editPasswordBtnPressed(_ sender: Any) {
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        createLogoutAlert()
    }
    
}


