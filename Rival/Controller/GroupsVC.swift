//
//  GroupsVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func signOutBtnPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print (error)
        }
    
    }
}
