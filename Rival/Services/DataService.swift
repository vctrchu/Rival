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
    
    
    func uploadDBUserCalendarEvent(uid: String, userData: Dictionary <String, Any>) {
        let calendarEventRef = REF_USERS.child(uid).child("calendarEvents")
        calendarEventRef.updateChildValues(userData)
    }
    
    func retrieveDBFullName() -> String {
        let uid = Auth.auth().currentUser?.uid
        let dataBaseFirstName = DataService.instance.REF_USERS.child(uid!).child("fullname")
        var fullname = ""

        dataBaseFirstName.observe(.value, with: { (snapshot) in
            
            let groupKeys = snapshot.children.compactMap { $0 as? DataSnapshot }.map { $0.key }
            
            // This group will keep track of the number of blocks still pending
            let group = DispatchGroup()
            
            for groupKey in groupKeys {
                group.enter()
                dataBaseFirstName.child("groups").child(groupKey).child("name").observeSingleEvent(of: .value, with: { snapshot in
                    group.leave()
                })
            }
            
            let name = snapshot.value as! String
            
            group.notify(queue: .main) {
                fullname = name
            }
        })
        
        return fullname
    }
    
    func getUserImage(uid: String, handler: @escaping (_ imageUrl: String) -> ()) {
        var imageUrls = [String]()
        var imageUrl = ""
        REF_USERS.observe(.value) { (snapshot) in
            
            if snapshot.hasChild(uid) {
                if snapshot.childSnapshot(forPath: uid).hasChild("profile_image") {
                    imageUrl = snapshot.childSnapshot(forPath: uid).childSnapshot(forPath: "profile_image").value as! String
                }
            }
//            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
//            for user in snapshot {
//                let imageUrl = user.childSnapshot(forPath: "profile_image").value as! String
//
//            }
            handler(imageUrl)
        }
    }
    
    
    func getFullName(forSearchQuery query: String, handler: @escaping (_ fullNameArray: [String]) -> ()) {
        var fullNameArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let fullName = user.childSnapshot(forPath: "fullname").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                
                if fullName.contains(query) == true && email != Auth.auth().currentUser?.email {
                    fullNameArray.append(fullName)
                }
            }
            handler(fullNameArray)
        }
    }
    
}
