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
import TransitionButton

class SignUpStep1VC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailIconImg: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextBtn: TransitionButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.emailIconImg.hop()
        }
        
        self.motionTransitionType = .autoReverse(presenting: MotionTransitionAnimationType.slide(direction: MotionTransitionAnimationType.Direction.left))
    }
    


    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSignUp2") {
            let signupVC2 = segue.destination as! SignUpStep2VC
            signupVC2.nameTxt = firstNameTxtField.text!
            signupVC2.userTxt = lastNameTxtField.text!
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        if (firstNameTxtField.text?.isEmpty)! || (lastNameTxtField.text?.isEmpty)! {
            nextBtn.shake()
            errorLabel.text = "Please make sure both fields are filled."            
        } else {
            errorLabel.text = ""
            performSegue(withIdentifier: "toSignUp2", sender: self)
        }
    }
    
    //Name and user label simple animations
    
    @IBAction func nameTxtFieldPressed(_ sender: Any) {
        nameLbl.hop()
    }
    
    @IBAction func lastNameTxtFieldPressed(_ sender: Any) {
        userLbl.hop()
    }
    

    
}
