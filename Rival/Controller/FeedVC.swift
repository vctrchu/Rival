//
//  FeedVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-23.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMessage { (returnMessagesArray) in
            self.messageArray = returnMessagesArray.reversed()
            self.tableView.reloadData()
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
        
        cell.configureCell(profileImage: message.senderProfileUrl, fullname: message.senderName, checkInNumber: "0", message: message.content)
        
//      cell.configureCell(profileImage: imageDict[userDict[nameArray[indexPath.row]]!]!, fullname: nameArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //destinationUID = uidArray[indexPath.row]
        //destinationName = fullNameArray[indexPath.row]
        //performSegue(withIdentifier: "SearchProfileSegue", sender: self)
    }
}
