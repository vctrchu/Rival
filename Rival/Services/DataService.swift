//
//  DataService.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-02-25.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static var instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    //Pushes users to firebase database
    func createDBUser(uid: String, userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
//    func getUserInfo(uid: String, info: String) -> String {
//        var returnString = "error"
//        switch info {
//        case "FullName":
//             REF_USERS.child(uid).child(info).observe(.value, with: { (snapshot) in
//                returnString = String(describing: snapshot.value)
//                print return
//            })
//
//        default:
//            returnString = "Does not exist"
//        }
//        return returnString
//    }
    
}
