//
//  ViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import RevealingSplashView
import TransitionButton
import SimpleAnimation


class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailaddressTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: TransitionButton!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        emailaddressTxtField.delegate = self
        passwordTxtField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        //Splash Animation
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "rivalIcon")!, iconInitialSize: CGSize(width: 123, height: 115), backgroundColor: #colorLiteral(red: 0.1490196078, green: 0.168627451, blue: 0.1764705882, alpha: 1))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
        

    }
    
    
    @IBAction func loginTransitionBtnPressed(_ sender: Any) {
        loginBtn.startAnimation()
    }
    
    @IBAction func noAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp1", sender: self)
    }
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //User and Lock image animations in textfield
    @IBAction func emailaddressTxtFieldTapped(_ sender: Any) {
        userIcon.hop()
    }
    @IBAction func passwordTxtFieldTapped(_ sender: Any) {
        lockIcon.hop()
    }

}

