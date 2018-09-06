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
    private var _REF_FEED = DB_BASE.child("feed")
    private var _REF_GROUPS = DB_BASE.child("groups")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    
    func uploadPost(withMessage message: String, forUID uid: String, name: String, profileUrl: String, withGroupKey groupKey: String?, sendComplete: @escaping(_ status: Bool) -> ()) {
        if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
                guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for message in messageSnapshot {
                    let messageKey = message.key
                    let senderId = message.childSnapshot(forPath: "senderId").value as! String
                    if senderId == uid {
                        self.REF_GROUPS.child(groupKey!).child("messages").child(messageKey).updateChildValues(["profileUrl": profileUrl])
                    }
                }
                sendComplete(true)
            }
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid, "name": name, "profileUrl": profileUrl])
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid, "name": name, "profileUrl": profileUrl])
            sendComplete(true)
        }
    }
    
    func updateAllFeedMessage(forGroupKey key: String?, handler: @escaping(_ status: Bool) ->()) {
        if key != nil {
            REF_GROUPS.child(key!).child("messages").observeSingleEvent(of: .value) { (messageSnapshot) in
                guard let messageSnapshot = messageSnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for message in messageSnapshot {
                    let senderId = message.childSnapshot(forPath: "senderId").value as! String
                    
                    self.getUserImage(uid: senderId, handler: { (returnedUrl) in
                        self.REF_GROUPS.child(key!).child("messages").child(message.key).updateChildValues(["profileUrl": returnedUrl])
                    })
                }
                handler(true)
            }
            
        } else {
            REF_FEED.observeSingleEvent(of: .value) { (postSnapshot) in
                guard let postSnapshot = postSnapshot.children.allObjects as? [DataSnapshot] else { return }
                
                for post in postSnapshot {
                    
                    let senderId = post.childSnapshot(forPath: "senderID").value as! String
                    
                    self.getUserImage(uid: senderId, handler: { (returnedUrl) in
                        self.REF_FEED.child(post.key).updateChildValues(["profileUrl": returnedUrl])
                    })
                }
                handler(true)
            }
        }
    }
    
    func getAllFeedMessage(handler: @escaping(_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_FEED.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for message in snapshot {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderID").value as! String
                let senderName = message.childSnapshot(forPath: "name").value as! String
                let url = message.childSnapshot(forPath: "profileUrl").value as! String
                
                let message = Message(content: content, senderId: senderId, senderName: senderName, senderProfielUrl: url)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping(_ messagesArray: [Message]) ->()) {
        var groupMessageArray = [Message]()
        
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let name = groupMessage.childSnapshot(forPath: "name").value as! String
                let profileUrl = groupMessage.childSnapshot(forPath: "profileUrl").value as! String
                let groupMessage = Message(content: content, senderId: senderId, senderName: name, senderProfielUrl: profileUrl)
                
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
        }
    }
    
    //Pushes users to firebase database
    func createDBUser(uid: String, userData: Dictionary <String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func numberOfFollowers(uid: String, handler: @escaping (_ numberOfFollowers: String) -> ()) {
        var numberOfFollowers = "0"
        
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            if snapshot.hasChild("followers") {
                numberOfFollowers = String(snapshot.childSnapshot(forPath: "followers").childrenCount)
            }
            handler(numberOfFollowers)
        }
    }
    
    func numberFollowing(uid: String, handler: @escaping (_ numberFollowing: String) -> ()) {
        var numberFollowing = "0"
        
        REF_USERS.child(uid).observe(.value) { (snapshot) in
            if snapshot.hasChild("following") {
                numberFollowing = String(snapshot.childSnapshot(forPath: "following").childrenCount)
            }
            handler(numberFollowing)
        }
    }
    
    func numberOfCheckIns(uid: String, handler: @escaping (_ numberCheckIns: String) -> ()) {
        var numberCheckIns = 0
        
        REF_USERS.child(uid).child("calendarEvents").observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value as! String
                
                if value == "check in" {
                    numberCheckIns += 1
                }
            }
            handler(String(numberCheckIns))
        }
    }
    
//    func updateFullName(name: String, handler: @escaping(_ status: Bool) -> ()) {
//        REF_USERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["fullname": name])
//        handler(true)
//    }
    
    //******* new follow functions
    func updateFollowing(uid: String, name: String, profileUrl: String, sendComplete: @escaping(_ status: Bool) -> ()) {
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("following").child(uid).updateChildValues(["name": name, "profileUrl": profileUrl])
        sendComplete(true)
    }
    
    func updateFollowers(uid: String, name: String, profileUrl: String, sendComplete: @escaping(_ status: Bool) -> ()) {
        REF_USERS.child(uid).child("followers").child((Auth.auth().currentUser?.uid)!).updateChildValues(["name": name, "profileUrl": profileUrl])
        sendComplete(true)
    }
    
    func deleteUserFromFollowing(uid: String) {
        let currentUserUID = Auth.auth().currentUser?.uid
        REF_USERS.child(currentUserUID!).child("following").child(uid).removeValue()
    }
    
    func deleteUserFromFollower(uid: String) {
        let currentUserUID = Auth.auth().currentUser?.uid
        REF_USERS.child(uid).child("followers").child(currentUserUID!).removeValue()
    }
 
    func uploadDBUserCalendarEvent(uid: String, userData: Dictionary <String, Any>) {
        let calendarEventRef = REF_USERS.child(uid).child("calendarEvents")
        calendarEventRef.updateChildValues(userData)
    }
    
    func getUserImage(uid: String, handler: @escaping (_ imageUrl: String) -> ()) {
        var imageUrl = "none"
        REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(uid) {
                if snapshot.childSnapshot(forPath: uid).hasChild("profile_image") {
                    imageUrl = snapshot.childSnapshot(forPath: uid).childSnapshot(forPath: "profile_image").value as! String
                }
            }
            handler(imageUrl)
        })
    }
    
    func getFullName(uid: String, handler: @escaping (_ fullName: String) -> ()) {
        var fullName = ""
        
        REF_USERS.child(uid).child("fullname").observeSingleEvent(of: .value) { (snapshot) in
            fullName = snapshot.value as! String
            handler(fullName)
        }
    }
    
    func checkIfFollowing(uid: String, handler: @escaping (_ check: Bool) -> ()) {
        var check = false
        
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("following").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(uid) {
                check = true
            }
            handler(check)
        }
    }
    
    func getCalendarEvents(uid: String, handler: @escaping(_ calendarEventsDictionary: [Date: String]) -> ()) {
        var calendarEventsDictionary = [Date: String]()
        
        REF_USERS.child(uid).child("calendarEvents").observeSingleEvent(of: .value) { (snapshot) in
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
    
    func getAllUserImages(uidArray: [String], handler: @escaping(_ imageDict: [String: String]) -> ()) {
        var imageDict = [String: String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in snapshot {
                var url = "none"
                if uidArray.contains(user.key) && user.hasChild("profile_image") {
                    url = user.childSnapshot(forPath: "profile_image").value as! String
                    imageDict[user.key] = url
                } else if uidArray.contains(user.key) && user.hasChild("profile_image") == false {
                    imageDict[user.key] = url
                }
                
            }
            handler(imageDict)
        }
    }
    
    func updateAllFollowerFollowing(uid: String, type: String, handler: @escaping(_ status: Bool) -> ()) {
        
        REF_USERS.child(uid).child(type).observeSingleEvent(of: .value) { (followerSnapshot) in
            guard let followerSnapshot = followerSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for follower in followerSnapshot {
                
                self.getUserImage(uid: follower.key, handler: { (returnedUrl) in
                    self.REF_USERS.child(uid).child(type).child(follower.key).updateChildValues(["profileUrl": returnedUrl])
                })
            }
            handler(true)
        }
    }
    
    func getAllFollowerFollowing(uid: String, type: String, handler: @escaping(_ followerArray: [Follower]) -> ()) {
        var followerArray = [Follower]()
        
        REF_USERS.child(uid).child(type).observeSingleEvent(of: .value) { (followerSnapshot) in
            guard let followerSnapshot = followerSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for child in followerSnapshot {
                let uid = child.key
                let name = child.childSnapshot(forPath: "name").value as! String
                let profileUrl = child.childSnapshot(forPath: "profileUrl").value as! String
                
                let follower = Follower(senderId: uid, senderName: name, senderProfielUrl: profileUrl)
                followerArray.append(follower)
            }
            handler(followerArray)
        }
    }
    
    func searchQueryForAllUsers(forSearchQuery query: String, handler: @escaping (_ userDictionary: [String: String],_ fullNameArray: [String], _ uidArray:[String]) -> ()) {
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
    
    func searchQueryFollowing(forSearchQuery query: String, handler: @escaping(_ followerArray: [Follower]) -> ()) {
        var followerArray = [Follower]()
        
        REF_USERS.child((Auth.auth().currentUser?.uid)!).child("following").observe(.value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for child in snapshot {
                let uid = child.key
                let name = child.childSnapshot(forPath: "name").value as! String
                let profileUrl = child.childSnapshot(forPath: "profileUrl").value as! String
                
                if name.contains(query.capitalized) == true || name.contains(query.lowercased()) {
                    let follower = Follower(senderId: uid, senderName: name, senderProfielUrl: profileUrl)
                    followerArray.append(follower)
                }
            }
            handler(followerArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping(_ groupCreated: Bool) ->()){
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping(_ groupsArray: [Group]) ->()) {
        var groupsArray = [Group]()
        
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, description: description, key: group.key, memberCount: memberArray.count, members: memberArray)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
    
    func getNamesFor(group: Group, handler: @escaping(_ NameArray: [String]) -> ()) {
        var nameArray = [String]()
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let name = user.childSnapshot(forPath: "fullname").value as! String
                    nameArray.append(name)
                }
            }
            handler(nameArray)
        }
    }
    
}
