//
//  UserCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-14.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var fullNameLbl: UILabel!
    
    @IBOutlet weak var followImg: UIImageView!
    
    func configureCell(profileImage image: UIImage, fullname: String) {
        self.profileImg.image = image
        self.fullNameLbl.text = fullname
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
