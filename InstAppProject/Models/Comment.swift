//
//  Comment.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import Foundation

struct Comment {
    
    let fromUserName: String
    let text: String
    
    init(commentDict: [String: Any]) {
        
        if let text = commentDict["text"] as? String {
            
            self.text = text
            
        } else {
            
            self.text = "no data"
        }
        
        if let from = commentDict["from"] as? [String: Any],
            let username = from["username"] as? String {
            
            self.fromUserName = username
            
        } else {
            
            self.fromUserName = "no name"
        }
    }
    
}

