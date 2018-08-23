//
//  FeedCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-23.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var checkInTimeLbl: UILabel!
    @IBOutlet weak var nameBtn: UIButton!
    
    func configureCell(profileImage url: String, fullname: String, checkInNumber: String) {
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        
        if url == "none" {
            let image = UIImage(named: "defaultProfilePic")
            self.profileImg.image = image
            self.descriptionLbl.text = "has checked in " + checkInNumber + " 5 days in a row!"
            //self.fullNameLbl.text = fullname
        } else {
            let imageUrl = URL(string: url)
            self.profileImg.kf.setImage(with: imageUrl)
            self.descriptionLbl.text = "has checked in " + checkInNumber + " 5 days in a row!"
            //self.fullNameLbl.text = fullname
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
