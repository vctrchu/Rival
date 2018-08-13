//
//  User.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-03-08.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var fullName: String!
    var email: String!
    var photoUrl: String?
    var ref: DatabaseReference?
    var key: String?
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        //firstName = (snapshot.value! as! NSDictionary)["firstname"] as! String
        //lastName = (snapshot.value! as! NSDictionary)["lastname"] as! String
        fullName = (snapshot.value! as! NSDictionary)["fullname"] as! String
        email = (snapshot.value! as! NSDictionary)["email"] as! String
        photoUrl = (snapshot.value! as! NSDictionary)["profile_image"] as! String

    }
}
