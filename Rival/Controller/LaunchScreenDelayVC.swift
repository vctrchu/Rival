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
import RAMAnimatedTabBarController

class LaunchScreenDelayVC: UIViewController, GroupsVCDelegate {

    private var groupsVCTabBarController: RAMAnimatedTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if Auth.auth().currentUser == nil {
                self.presentLoginScreen()
            } else {
                if let groupsVCTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? RAMAnimatedTabBarController {
                    self.groupsVCTabBarController = groupsVCTabBarController
                    groupsVCTabBarController.modalTransitionStyle = .crossDissolve
                    if let groupsVC = groupsVCTabBarController.viewControllers?.first as? GroupsVC {
                        groupsVC.delegate = self
                    }
                    self.present(groupsVCTabBarController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func presentLoginScreen() {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        loginVC!.modalTransitionStyle = .crossDissolve
        self.present(loginVC!, animated: true, completion: nil)
    }

    func onLogoutPressed() {
        groupsVCTabBarController?.dismiss(animated: false, completion: {
            self.presentLoginScreen()
        })
    }
}
