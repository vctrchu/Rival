//
//  GroupCellTableViewCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    var showing = false
    
    func configureCell(profileImage url: String, name: String, isSelected: Bool) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.masksToBounds = true
        
        if isSelected {
            self.checkmarkImage.isHidden = false
        } else {
            self.checkmarkImage.isHidden = true
        }
        
        if url == "none" {
            let image = UIImage(named: "defaultProfilePic")
            self.profileImage.image = image
            self.NameLabel.text = name
        } else {
            let imageUrl = URL(string: url)
            self.profileImage.kf.setImage(with: imageUrl)
            self.NameLabel.text = name
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            if showing == false {
                checkmarkImage.isHidden = false
                showing = true
            } else {
                checkmarkImage.isHidden = true
                showing = false
            }
        }
    }

}
