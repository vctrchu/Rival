//
//  SignUpVC.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-25.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit


class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var userTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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

}
