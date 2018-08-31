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

protocol SignUpVC1Delegate: class {
    func onLogoutPressed()
}

class SignUpStep1VC: UIViewController, UITextFieldDelegate, SignUpVC2Delegate {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var emailIconImg: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nextBtn: TransitionButton!
    
    private var signUpStep2Controller: SignUpStep2VC?
    weak var delegate: SignUpVC1Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTxtField.delegate = self
        lastNameTxtField.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.emailIconImg.hop()
        }
        
        self.motionTransitionType = .autoReverse(presenting: MotionTransitionAnimationType.slide(direction: MotionTransitionAnimationType.Direction.left))
    }
    
    //MARK: - Controlling the Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        if textField == firstNameTxtField {
            textField.resignFirstResponder()
            lastNameTxtField.becomeFirstResponder()
        } else if textField == lastNameTxtField {
            textField.resignFirstResponder()
            nextButton()
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUp2" {
            if let signupVC2 = segue.destination as? SignUpStep2VC {
                self.signUpStep2Controller = signupVC2
                signupVC2.delegate = self
                let fullName = firstNameTxtField.text!.capitalized + " " + lastNameTxtField.text!.capitalized
                signupVC2.fullNameTxt = fullName
            }
        }
    }
    
    func nextButton() {
        if (firstNameTxtField.text?.isEmpty)! || (lastNameTxtField.text?.isEmpty)! {
            nextBtn.shake()
            errorLabel.text = "Please make sure both fields are filled."
        } else {
            errorLabel.text = ""
            performSegue(withIdentifier: "toSignUp2", sender: self)
        }
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        nextButton()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Name and user label simple animations.
    @IBAction func nameTxtFieldPressed(_ sender: Any) {
        nameLbl.hop()
    }
    
    @IBAction func lastNameTxtFieldPressed(_ sender: Any) {
        userLbl.hop()
    }
    
    func onLogoutPressed() {
        firstNameTxtField.text = nil
        lastNameTxtField.text = nil
        signUpStep2Controller?.dismiss(animated: false, completion: {
            self.delegate?.onLogoutPressed()
        })
    }

}
