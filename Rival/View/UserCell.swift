//
//  UserCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-14.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Kingfisher

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var fullNameLbl: UILabel!
    
    func configureCell(profileImage url: String, fullname: String) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        
        if url == "none" {
            let image = UIImage(named: "defaultProfilePic")
            self.profileImg.image = image
            self.fullNameLbl.text = fullname
        } else {
            let imageUrl = URL(string: url)
            self.profileImg.kf.setImage(with: imageUrl)
            self.fullNameLbl.text = fullname
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }


}
