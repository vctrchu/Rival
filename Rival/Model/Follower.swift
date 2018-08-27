//
//  Follower.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-26.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation


class Follower {
    private var _senderId: String
    private var _senderName: String
    private var _senderProfileUrl: String
    
    var senderId: String {
        return _senderId
    }
    
    var senderName: String {
        return _senderName
    }
    
    var senderProfileUrl: String {
        return _senderProfileUrl
    }
    
    init(senderId: String, senderName: String, senderProfielUrl: String) {
        self._senderId = senderId
        self._senderName = senderName
        self._senderProfileUrl = senderProfielUrl
    }
}
