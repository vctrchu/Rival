//
//  ViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import TransitionButton
import SimpleAnimation
import Motion

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
    }
    
    
    @IBAction func loginTransitionBtnPressed(_ sender: Any) {
        if emailaddressTxtField.text != nil && passwordTxtField.text != nil {
            loginBtn.startAnimation()
            AuthService.instance.loginUser(withEmail: emailaddressTxtField.text!, andPassword: passwordTxtField.text!, loginComplete: { (success, loginError) in
                if success {
                    self.loginBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                        let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                        mainVC!.modalTransitionStyle = .crossDissolve
                        self.present(mainVC!, animated: true, completion: nil)
                    })
                } else {
                    print(String(describing: loginError?.localizedDescription))
                    self.loginBtn.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 0.75, completion: nil)
                }
            })
        }
        
        
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

