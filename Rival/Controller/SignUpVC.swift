//
//  SignUpVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-25.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import SimpleAnimation
import Motion

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailIconImg: UIImageView!
    @IBOutlet weak var passwordIconImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            if self.restorationIdentifier == "SignUpVC1" {
                self.emailIconImg.hop()
            } else if self.restorationIdentifier == "SignUpVC2" {
                self.passwordIconImg.hop()
            }
        }
        
        self.motionTransitionType = .autoReverse(presenting: MotionTransitionAnimationType.slide(direction: MotionTransitionAnimationType.Direction.left))
    }
    


    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func alreadyHaveAccPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLoginVC", sender: self)
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp2", sender: self)
    }
    
    
    
    
    //Name and user label simple animations
    
    @IBAction func nameTxtFieldPressed(_ sender: Any) {
        nameLbl.hop()
    }
    
    @IBAction func userTxtFieldPressed(_ sender: Any) {
        userLbl.hop()
    }
    
    @IBAction func emailTxtFieldPressed(_ sender: Any) {
        emailLbl.hop()
    }
    @IBAction func passwordTxtFieldPressed(_ sender: Any) {
        passwordLbl.hop()
    }
    
}
