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
        if  emailTxtField.text != nil && passwordTxtField.text != nil {
            completeBtn.startAnimation()
            AuthService.instance.registerUser(fullName: nameTxt, userName: userTxt, withEmail: emailTxtField.text!, andPassword: passwordTxtField.text!, userCreationComplete: { (success, signupError) in
                if success {
                    AuthService.instance.loginUser(withEmail: self.emailTxtField.text!, andPassword: self.passwordTxtField.text!, loginComplete: { (success, nil) in
                        self.completeBtn.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                            mainVC!.modalTransitionStyle = .crossDissolve
                            self.present(mainVC!, animated: true, completion: nil)
                        })
                    })
                } else {
                    print(String(describing: signupError?.localizedDescription))
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
