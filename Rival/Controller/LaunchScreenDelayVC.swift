//
//  LaunchScreenDelayVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import Motion

class LaunchScreenDelayVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if Auth.auth().currentUser == nil {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                loginVC!.modalTransitionStyle = .crossDissolve
                self.present(loginVC!, animated: true, completion: nil)
            } else {
                let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                mainVC!.modalTransitionStyle = .crossDissolve
                self.present(mainVC!, animated: true, completion: nil)
            }
        }
    }

}
