//
//  GroupFeedCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-27.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Kingfisher

class GroupMessagesCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var messageContent: UILabel!
    
    func configureCell(profileUrl: String, name: String, messageContent: String) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
        if profileUrl == "none" {
            let image = UIImage(named: "defaultProfilePic")
            self.profileImage.image = image
            self.name.text = name
            self.messageContent.text = messageContent
        } else {
            let imageUrl = URL(string: profileUrl)
            self.profileImage.kf.setImage(with: imageUrl)
            self.name.text = name
            self.messageContent.text = messageContent
        }
    }
}
