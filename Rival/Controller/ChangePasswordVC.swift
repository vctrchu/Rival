//
//  ChangePasswordVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-09-07.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import IHKeyboardAvoiding

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardAvoiding.avoidingView = self.stackView
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Please enter old password to continue.", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            SVProgressHUD.show()
            let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: (textField?.text!)!)
            
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if let error = error {
                    print("error with credentials")
                    self.errorLabel.text = String(describing: error.localizedDescription)
                    SVProgressHUD.dismiss()
                } else {
                    Auth.auth().currentUser?.updatePassword(to: self.passwordTxtField.text!, completion: { (error) in
                        if let error = error {
                            self.errorLabel.text = String(describing: error.localizedDescription)
                            SVProgressHUD.dismiss()
                        } else {
                            SVProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
}
