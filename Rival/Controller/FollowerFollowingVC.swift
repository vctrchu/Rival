//
//  FollowerFollowingVCViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-21.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Hero
import Firebase

class FollowerFollowingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var typeOfVC = ""
    var nameArray = [String]()
    var uidArray = [String]()
    var userDict = [String: String]()
    var imageDict = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupVC()
    }
    
    func setupVC() {
        
        let uid = Auth.auth().currentUser?.uid
        
        var _nameArray = [String]()
        var _uidArray = [String]()
        var _userDict = [String: String]()
        
        if typeOfVC == "followers" {
            
            DataService.instance.getAllFollowerFollowing(uid: uid!, type: "followers") { (returnUidArray, returnNameArray, returnUserDict) in

                _userDict = returnUserDict
                _uidArray = returnUidArray
                _nameArray = returnNameArray
                
                
                DataService.instance.getAllUserImages(uidArray: _uidArray) { (returnImageDict) in
                    self.imageDict = returnImageDict
                    self.userDict = _userDict
                    self.uidArray = _uidArray
                    self.nameArray = _nameArray
                    self.tableView.reloadData()
                }
            }
        } else if typeOfVC == "following" {
            DataService.instance.getAllFollowerFollowing(uid: uid!, type: "following") { (returnUidArray, returnNameArray, returnUserDict) in
                
                _userDict = returnUserDict
                _uidArray = returnUidArray
                _nameArray = returnNameArray
                
                
                DataService.instance.getAllUserImages(uidArray: _uidArray) { (returnImageDict) in
                    self.imageDict = returnImageDict
                    self.userDict = _userDict
                    self.uidArray = _uidArray
                    self.nameArray = _nameArray
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }
    
}

extension FollowerFollowingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        
        cell.configureCell(profileImage: imageDict[userDict[nameArray[indexPath.row]]!]!, fullname: nameArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //destinationUID = uidArray[indexPath.row]
        //destinationName = fullNameArray[indexPath.row]
        //performSegue(withIdentifier: "SearchProfileSegue", sender: self)
    }
}
