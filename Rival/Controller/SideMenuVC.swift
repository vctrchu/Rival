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
    @IBOutlet weak var followersBtn: UIButton!
    @IBOutlet weak var followingBtn: UIButton!
        
    weak var delegate: SideMenuVCDelegate?
    
    var typeOfVC = ""
    
    var nameArray = [String]()
    var uidArray = [String]()
    var userDict = [String: String]()
    var imageDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setUser()
        sideMenuCustomization()
        outletCustomization()
        addTapGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUser()
    }
    
    func addTapGestures() {
        let imageTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SideMenuVC.imgAction))
        profileImg.addGestureRecognizer(imageTap)
    }
    
    func setUser() {
        let uid = Auth.auth().currentUser?.uid
        
        DataService.instance.getFullName(uid: uid!) { (name) in
            self.fullNameLbl.text = name.uppercased()
        }
        DataService.instance.getUserImage(uid: uid!) { (url) in
            if url == "none" {
                let image = UIImage(named: "defaultProfilePic")
                self.profileImg.image = image
            } else {
                let imageUrl = URL(string: url)
                self.profileImg.kf.setImage(with: imageUrl)
            }
        }
        
        DataService.instance.numberFollowing(uid: uid!) { (returnNumber) in
            let title = NSAttributedString(string: returnNumber + " Following", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.followingBtn.setAttributedTitle(title, for: UIControl.State.normal)
        }
        
        DataService.instance.numberOfFollowers(uid: uid!) { (returnNumber) in
            let title = NSAttributedString(string: returnNumber + " Followers", attributes:
                [.underlineStyle: NSUnderlineStyle.single.rawValue])
            self.followersBtn.setAttributedTitle(title, for: UIControl.State.normal)
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
        let alert = UIAlertController(title: "Are you sure you want to log out of Rival?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let logoutFailure = UIAlertController(title: "Logout failed. Please try again or check your connection", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                self.delegate?.onLogoutPressed()
            } catch {
                print(error)
                self.present(logoutFailure, animated: true, completion: nil)
            }
        }))
        
        logoutFailure.addAction(UIAlertAction(title: "Dimiss", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imgAction(){
        performSegue(withIdentifier: "SideMenuToProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SideMenuToProfile" {
            if let destinationVC = segue.destination as? ProfilePageVC {
                destinationVC.uid = (Auth.auth().currentUser?.uid)!
                destinationVC.name = fullNameLbl.text!
                destinationVC.typeOfProfile = "self"
            }
        } else if segue.identifier == "SideMenuToFollowerFollowing" {
            if let destinationVC = segue.destination as? FollowerFollowingVC {
                destinationVC.typeOfVC = typeOfVC
            }
        }
    }
    @IBAction func followersBtnPressed(_ sender: Any) {
        typeOfVC = "followers"
        performSegue(withIdentifier: "SideMenuToFollowerFollowing", sender: self)
    }
    
    @IBAction func followingBtnPressed(_ sender: Any) {
        typeOfVC = "following"
        performSegue(withIdentifier: "SideMenuToFollowerFollowing", sender: self)
    }
    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC")
        present(editProfileVC!, animated: true, completion: nil)
    }
    
    @IBAction func editPasswordBtnPressed(_ sender: Any) {
        let editPasswordVC = storyboard?.instantiateViewController(withIdentifier: "EditPasswordVC")
        present(editPasswordVC!, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        createLogoutAlert()
    }
    
}


