//
//  FeedVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-23.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    var destinationUid = ""
    var destinationName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SVProgressHUD.show()
        DataService.instance.updateAllFeedMessage(forGroupKey: nil) { (isComplete) in
            if isComplete {
                DataService.instance.getAllFeedMessage { (returnMessagesArray) in
                    self.messageArray = returnMessagesArray.reversed()
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            } else {
                print("fail to update feed.")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedToProfile" {
            if let destinationVC = segue.destination as? ProfilePageVC {
                destinationVC.hero.isEnabled = true
                destinationVC.hero.modalAnimationType = .slide(direction: .left)
                if destinationUid == Auth.auth().currentUser?.uid {
                    destinationVC.uid = destinationUid
                    destinationVC.name = destinationName
                    destinationVC.typeOfProfile = "self"
                } else {
                    destinationVC.uid = destinationUid
                    destinationVC.name = destinationName
                    destinationVC.typeOfProfile = "other"
                }
            }
        }
    }
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell() }
        
        let message = messageArray[indexPath.row]
        
        cell.configureCell(profileImage: message.senderProfileUrl, fullname: message.senderName, message: message.content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        destinationUid = messageArray[indexPath.row].senderId
        destinationName = messageArray[indexPath.row].senderName
        performSegue(withIdentifier: "FeedToProfile", sender: self)
    }
}
