//
//  ViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import SKSplashView

class LoginVC: UIViewController {
    
    
    let splashview = SKSplashView(splashIcon: SKSplashIcon(image: UIImage(named: "rivalIcon"), animationType: SKIconAnimationType.bounce), backgroundColor: #colorLiteral(red: 0.1490196078, green: 0.168627451, blue: 0.1764705882, alpha: 1), animationType: SKSplashAnimationType.none)


    override func viewDidLoad() {
        super.viewDidLoad()
        startSplashViewAnimation()
        
    }
    
    func startSplashViewAnimation() {
        splashview?.animationDuration = 3.0
        self.view.addSubview(splashview!)
        splashview?.startAnimation()
    }
    



}

