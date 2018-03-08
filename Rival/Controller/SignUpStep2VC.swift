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

class SignUpStep2VC: UIViewController {

    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordIconImg: UIImageView!
    @IBOutlet weak var completeBtn: TransitionButton!
    
    var nameTxt = ""
    var userTxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.passwordIconImg.hop()
        }
        
        self.motionTransitionType = .autoReverse(presenting: MotionTransitionAnimationType.slide(direction: MotionTransitionAnimationType.Direction.left))
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLoginVC", sender: self)
    }
    
    
    @IBAction func completeBtnPressed(_ sender: Any) {
        if  let email = emailTxtField.text, let password = passwordTxtField.text {
            completeBtn.startAnimation()
            AuthService.instance.registerUser(fullName: nameTxt, userName: userTxt, withEmail: email, andPassword: password, userCreationComplete: { (success, signupError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
                        self.completeBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC")
                            tabBarVC!.modalTransitionStyle = .crossDissolve
                            self.present(tabBarVC!, animated: true, completion: nil)
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

  
    
    
    
    
    
    
    
    @IBAction func emailTxtFieldPressed(_ sender: Any) {
        emailLbl.hop()
    }

    @IBAction func passwordTxtFieldPressed(_ sender: Any) {
        passwordLbl.hop()
    }

}
