//
//  CreatePostVCViewController.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    var name = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        postBtn.bindToKeyboard()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getFullName(uid: (Auth.auth().currentUser?.uid)!) { (returnName) in
            self.name = returnName
        }
        DataService.instance.getUserImage(uid: (Auth.auth().currentUser?.uid)!) { (returnUrl) in
            self.url = returnUrl
        }
    }

    @IBAction func postBtnPressed(_ sender: Any) {
        if textView.text != nil && textView.text != "Say something here..." && textView.text != "" {
            postBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, name: name, profileUrl: url, withGroupKey: nil) { (isComplete) in
                if isComplete {
                    self.postBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.postBtn.isEnabled = true
                    print("There was an error")
                }
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
