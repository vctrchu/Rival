//
//  ViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import RevealingSplashView

class LoginVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Splashview Animation
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "rivalIcon")!, iconInitialSize: CGSize(width: 123, height: 115), backgroundColor: #colorLiteral(red: 0.1490196078, green: 0.168627451, blue: 0.1764705882, alpha: 1))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()

    }

    

}

