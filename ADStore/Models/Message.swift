//
//  Message.swift
//  ADStore
//
//  Created by Naji Kanounji on 2/22/21.
//  Copyright © 2021 Naji Kanounji. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?

    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.toId = dictionary["toId"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.imageWidth = dictionary["imageWidth"] as? NSNumber

    }
    
    // get userName as string from toId || fromId
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
/*
extension Message: MessageType {
    var sender: SenderType {
        return Sender(id: fromId!, displayName: fromId!)
    }
    var messageId: String {
        return UUID().uuidString
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text ?? "")
    }
}
*/
