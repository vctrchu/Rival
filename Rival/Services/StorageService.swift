//
//  StorageService.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-03-07.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

let STORAGE_BASE = Storage.storage().reference()

class StorageService {
    static var instance = StorageService()
    
    private var _REF_BASE = STORAGE_BASE
    private var _REF_PROFILEIMAGE = STORAGE_BASE.child("profile_image")
    
    var REF_BASE: StorageReference {
        return _REF_BASE
    }
    
    var REF_PROFILEIMAGE: StorageReference {
        return _REF_PROFILEIMAGE
    }
    
    func uploadProfileImage(uid: String, data: Data) {
        REF_PROFILEIMAGE.child(uid).putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            let profileImageUrl = metadata.downloadURL()?.absoluteString
            let userData = ["profile_image": profileImageUrl!]
            DataService.instance.createDBUser(uid: Auth.auth().currentUser!.uid , userData: userData)
        }
    }
    
}
