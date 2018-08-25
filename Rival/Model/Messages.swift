//
//  File.swift
//  Rival
//
//  Created by VICTOR CHU on 2018-08-24.
//  Copyright © 2018 Victor Chu. All rights reserved.
//

import Foundation

class Message {
    private var _content: String
    private var _senderId: String
    private var _senderName: String
    private var _senderProfileUrl: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    var senderName: String {
        return _senderName
    }
    
    var senderProfileUrl: String {
        return _senderProfileUrl
    }
    
    init(content: String, senderId: String, senderName: String, senderProfielUrl: String) {
        self._content = content
        self._senderId = senderId
        self._senderName = senderName
        self._senderProfileUrl = senderProfielUrl
    }
 }
