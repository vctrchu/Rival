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
    var followerArray = [Follower]()
    var destinationUid = ""
    var destinationName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupVC()
    }
    
    func setupVC() {
        
        let uid = Auth.auth().currentUser?.uid
        
        if typeOfVC == "followers" {
            DataService.instance.getAllFollowerFollowing(uid: uid!, type: "followers") { (returnFollowerArray) in
                self.followerArray = returnFollowerArray
            }
        } else if typeOfVC == "following" {
            DataService.instance.getAllFollowerFollowing(uid: uid!, type: "following") { (returnFollowerArray) in
                self.followerArray = returnFollowerArray
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FollowerFollowingToProfilePage" {
            if let destinationVC = segue.destination as? ProfilePageVC {
                destinationVC.uid = destinationUid
                destinationVC.name = destinationName
                destinationVC.typeOfProfile = "other"
            }
        }
    }
    
}

extension FollowerFollowingVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        
        let follower = followerArray[indexPath.row]
        
        cell.configureCell(profileImage: follower.senderProfileUrl, fullname: follower.senderName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        destinationUid = followerArray[indexPath.row].senderId
        destinationName = followerArray[indexPath.row].senderName
        performSegue(withIdentifier: "FollowerFollowingToProfilePage", sender: self)
    }
}
