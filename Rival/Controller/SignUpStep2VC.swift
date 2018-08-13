//
//  SignUpStep2VC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Motion
import SimpleAnimation
import TransitionButton
import RAMAnimatedTabBarController

class SignUpStep2VC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordIconImg: UIImageView!
    @IBOutlet weak var completeBtn: TransitionButton!
    
    private var calendarVCTabBarController: RAMAnimatedTabBarController?

    var fullNameTxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtField.delegate = self
        passwordTxtField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.passwordIconImg.hop()
        }
        
        self.motionTransitionType = .autoReverse(presenting: MotionTransitionAnimationType.slide(direction: MotionTransitionAnimationType.Direction.left))
        
    }
    
    //MARK: - Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTxtField {
            textField.resignFirstResponder()
            passwordTxtField.becomeFirstResponder()
        } else if textField == passwordTxtField {
            textField.resignFirstResponder()
            registerUser()
        }
        return true
    }
    
    func registerUser() {
        if  let email = emailTxtField.text, let password = passwordTxtField.text {
            completeBtn.startAnimation()
            AuthService.instance.registerUser(fullName: fullNameTxt, withEmail: email, andPassword: password, userCreationComplete: { (success, signupError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
                        self.completeBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                            
                            if let calendarVCTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? RAMAnimatedTabBarController {
                                self.calendarVCTabBarController = calendarVCTabBarController
                                calendarVCTabBarController.modalTransitionStyle = .crossDissolve
                                self.calendarVCTabBarController?.selectedIndex = 1
                                self.present(calendarVCTabBarController, animated: true, completion: nil)
                            }
//                            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
//                            tabBarVC!.modalTransitionStyle = .crossDissolve
//
//                            self.present(tabBarVC!, animated: true, completion: nil)
                        })
                    })
                } else {
                    print(String(describing: signupError?.localizedDescription))
                    self.errorLbl.text = String(describing: signupError!.localizedDescription)
                    self.errorLbl.hop()
                    self.completeBtn.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 1, completion: nil)
                }
            })
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLoginVC", sender: self)
    }
    
    
    @IBAction func completeBtnPressed(_ sender: Any) {
        registerUser()
    }
        
    
    
    @IBAction func emailTxtFieldPressed(_ sender: Any) {
        emailLbl.hop()
    }

    @IBAction func passwordTxtFieldPressed(_ sender: Any) {
        passwordLbl.hop()
    }

}
