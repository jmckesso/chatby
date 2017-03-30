//
//  Message.swift
//  chatby
//
//  Created by Tanner Strom on 3/29/17.
//  Copyright © 2017 Jacob McKesson. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class Message : NSObject, JSQMessageData {
    var text_: String
    var senderName: String
    var senderID: String
    var date_: NSDate
    var imageUrl_: String?
    
    convenience init(text: String?, senderName: String?, senderID: String?) {
        self.init(text: text, senderName: senderName, senderID: senderID, imageUrl: nil)
    }
    
    init(text: String?, senderName: String?, senderID: String?, imageUrl: String?) {
        self.text_ = text!
        self.senderName = senderName!
        self.senderID = senderID!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
    }
    
    func text() -> String! {
        return text_
    }
    
    func senderDisplayName() -> String! {
        return senderName
    }
    func senderId() -> String! {
        return senderID
    }
    
    func date() -> Date! {
        return date_ as Date!;
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return UInt(hash)
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}
