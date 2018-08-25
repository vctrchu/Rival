//
//  FeedCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-23.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var checkInTimeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    func configureCell(profileImage url: String, fullname: String, checkInNumber: String, message: String) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.layer.masksToBounds = true
        
        if url == "none" {
            let image = UIImage(named: "defaultProfilePic")
            self.profileImg.image = image
            self.descriptionLbl.text = message
            self.nameLbl.text = fullname
        } else {
            let imageUrl = URL(string: url)
            self.profileImg.kf.setImage(with: imageUrl)
            self.descriptionLbl.text = message
            self.nameLbl.text = fullname
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
