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
import RAMAnimatedTabBarController
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, GroupsVCDelegate {
    
    @IBOutlet weak var emailaddressTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var loginBtn: TransitionButton!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    private var groupsVCTabBarController: RAMAnimatedTabBarController?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailaddressTxtField.delegate = self
        passwordTxtField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK: - Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailaddressTxtField {
            textField.resignFirstResponder()
            passwordTxtField.becomeFirstResponder()
        } else if textField == passwordTxtField {
            textField.resignFirstResponder()
            loginUser()
        }
        return true
    }
    
    
    func loginUser() {
        if let email = emailaddressTxtField.text, let password = passwordTxtField.text {
            loginBtn.startAnimation()
            AuthService.instance.loginUser(withEmail: email, andPassword: password, loginComplete: { (success, loginError) in
                if success {
                    self.loginErrorLabel.text = " "
                    self.loginBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                        if let groupsVCTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? RAMAnimatedTabBarController {
                            self.groupsVCTabBarController = groupsVCTabBarController
                            groupsVCTabBarController.modalTransitionStyle = .crossDissolve
                            if let groupsVC = groupsVCTabBarController.viewControllers?.first as? HomeVC {
                                groupsVC.delegate = self
                            }
                            self.present(groupsVCTabBarController, animated: true, completion: nil)
                        }
                    })
                } else {
                    print(String(describing: loginError?.localizedDescription))
                    self.loginBtn.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 0.75, completion: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                        self.loginErrorLabel.text = "Incorrect email and/or password."
                    }
                }
            })
        }
    }
    
    @IBAction func loginTransitionBtnPressed(_ sender: Any) {
        loginUser()
    }
    
    @IBAction func noAccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp1", sender: self)
        self.loginErrorLabel.text = " "
    }
    
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: <#T##String#>, completion: <#T##SendPasswordResetCallback?##SendPasswordResetCallback?##(Error?) -> Void#>)
    }
    
    
    
    
    
    
    
    
    
    // Second new account screen when already have an account button is pressed
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
    }
    
    //User and Lock image animations in textfield
    @IBAction func emailaddressTxtFieldTapped(_ sender: Any) {
        userIcon.hop()
    }
    @IBAction func passwordTxtFieldTapped(_ sender: Any) {
        lockIcon.hop()
    }
    
    func onLogoutPressed() {
        emailaddressTxtField.text = nil
        passwordTxtField.text = nil
        groupsVCTabBarController?.dismiss(animated: false, completion: nil)
    }

}

