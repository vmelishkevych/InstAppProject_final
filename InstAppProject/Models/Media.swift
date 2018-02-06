//
//  Media.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import Foundation
import UIKit

class Media {
    
    var takenPhoto: String?
    var takenThumbnail: String?
    var user_id: String?
    var userName: String?
    var avatarURL: String?
    
    var comments: [Comment]? {
        
        didSet {
            
            print("!!!!!New value Of Comments:", comments as Any)
            /*
            if comments != nil {
                
                DispatchQueue.main.async {
                    
                    let window = UIApplication.shared.keyWindow
                    
                    let navigationController = window!.rootViewController as! UINavigationController
                    
                    let postController = navigationController.topViewController! as! FeedTableViewController
                    
                    postController.tableView.reloadData()
                }
            }
 */
        }
    }
    
    var time: String?
    var likes: Int?
}
