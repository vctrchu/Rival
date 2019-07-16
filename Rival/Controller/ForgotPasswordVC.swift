//
//  ResetPasswordVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-07-30.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import SimpleAnimation
import Firebase
import TransitionButton
import IHKeyboardAvoiding

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var sendButton: TransitionButton!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        self.hideKeyboardWhenTappedAround()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.lockImage.hop()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardAvoiding.avoidingView = self.sendButton
    }
    
    func resetPassword() {
        if let email = emailTextfield.text {
            sendButton.startAnimation()
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    self.sendButton.stopAnimation(animationStyle: StopAnimationStyle.shake, revertAfterDelay: 0.75, completion: nil)
                    self.errorMessage.text = String(error.localizedDescription)
                    
                } else {
                    self.sendButton.stopAnimation()
                    self.sendButton.isEnabled = false
                    let alert = UIAlertController(title: "Password Reset Success!", message: "Please check your email and follow the instructions.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dimiss", style: UIAlertAction.Style.default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        resetPassword()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            textField.resignFirstResponder()
            resetPassword()
        }
        return true
    }
}
