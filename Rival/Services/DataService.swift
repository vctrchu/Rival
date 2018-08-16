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
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    //Pushes users to firebase database
    func createDBUser(uid: String, userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    func uploadDBUserCalendarEvent(uid: String, userData: Dictionary <String, Any>) {
        let calendarEventRef = REF_USERS.child(uid).child("calendarEvents")
        calendarEventRef.updateChildValues(userData)
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
            handler(imageUrl)
        }
    }
    
    func getCalendarEvents(uid: String, handler: @escaping(_ calendarEventsDictionary: [Date: String]) -> ()) {
        
        var calendarEventsDictionary = [Date: String]()
        
        REF_USERS.child(uid).child("calendarEvents").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key as String
                let value = snap.value as! String
                
                let addedDate = key
                self.formatter.dateFormat = "yyyy MM dd"
                let date = self.formatter.date(from: addedDate)
                
                calendarEventsDictionary[date!] = value
            }
            handler(calendarEventsDictionary)
        }
    }
    
    func getFullNamePictureUID(forSearchQuery query: String, handler: @escaping (_ userDictionary: [String: String],_ fullNameArray:[String], _ uidArray:[String]) -> ()) {
        var userDictionary = [String: String]()
        var fullNameArray = [String]()
        var uidArray = [String]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                var url = "none"
                let fullName = user.childSnapshot(forPath: "fullname").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                let uid = user.key
                
                if user.hasChild("profile_image") {
                    url = user.childSnapshot(forPath: "profile_image").value as! String
                }
                
                if fullName.contains(query) == true && email != Auth.auth().currentUser?.email {
                    userDictionary[fullName] = url
                    fullNameArray.append(fullName)
                    uidArray.append(uid)
                }
            }
            handler(userDictionary,fullNameArray,uidArray)
        }
    }
    
}
