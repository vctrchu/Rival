//
//  GroupFeedVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-27.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Hero
import Firebase
import IHKeyboardAvoiding

class GroupMessagesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var group: Group?
    var groupMessages = [Message]()
    var offsetY:CGFloat = 0
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardAvoiding.avoidingView = self.sendBtnView
        groupTitleLabel.text = group?.groupTitle
        
        DataService.instance.getNamesFor(group: group!) { (returnedNames) in
            self.membersLabel.text = returnedNames.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.updateAllFeedMessage(forGroupKey: self.group?.key, handler: { (isComplete) in
                if isComplete {
                    DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                        self.groupMessages = returnedGroupMessages
                        self.tableView.reloadData()
                        
                        if self.groupMessages.count > 0 {
                            self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                        }
                    })
                } else {
                    print("failed to update group feed.")
                }
            })
            
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnedName) in
                let name = returnedName
                DataService.instance.getUserImage(uid: (Auth.auth().currentUser?.uid)!, handler: { (returnedProfileUrl) in
                    let profileUrl = returnedProfileUrl
                    DataService.instance.uploadPost(withMessage: self.messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, name: name, profileUrl: profileUrl, withGroupKey: self.group?.key, sendComplete: { (isComplete) in
                        if isComplete {
                            self.messageTextField.text = ""
                            self.messageTextField.isEnabled = true
                            self.sendButton.isEnabled = true
                        }
                    })
                })
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.hero.modalAnimationType = .slide(direction: .right)
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension GroupMessagesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupMessagesCell") as? GroupMessagesCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        let groupMessage = groupMessages[indexPath.row]
        cell.configureCell(profileUrl: groupMessage.senderProfileUrl, name: groupMessage.senderName, messageContent: groupMessage.content)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
