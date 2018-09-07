//
//  MessageGroupCell.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-27.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit

class MessageGroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescripLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLabel.text = title
        self.groupDescripLabel.text = description
        self.memberCountLabel.text = "\(memberCount) members."
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
