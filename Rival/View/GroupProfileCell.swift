//
//  GroupProfileCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-03-07.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(profileImage: UIImage, name: String) {
        self.profileImage.image = profileImage
        self.nameLabel.text = name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
