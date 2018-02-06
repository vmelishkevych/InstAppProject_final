//
//  ProfileView.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit

class ProfileView: UICollectionReusableView {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userPosts: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    


    
    var user: User? {
        
        didSet {
            
            if let setUser = user {

                // set followers
                
                let followers: String
                
                if let count = setUser.followers {
                    followers = String(count)
                } else {
                    followers = "no data"
                }
                
                userFollowers.text = "followers: " + followers


                // set follows
                
                let follows: String
                
                if let count = setUser.follows {
                    follows = String(count)
                } else {
                    follows = "no data"
                }
                
                userFollowing.text = "followed_by: " + follows
                

                // set posts
                
                let posts: String
                
                if let count = setUser.post {
                    posts = String(count)
                } else {
                    posts = "no data"
                }
                
                userPosts.text = "posts: " + posts

                
                // set photo
                
                if let stringURL = setUser.avatarURL {
                    
                    SessionTasksApi.imageFor(stringURL: stringURL) { (image) in
                        
                        DispatchQueue.main.async {
                            self.userImage.image = image ?? UIImage(named: "no_image")
                        }
                    }
                } else {
                    
                    self.userImage.image = UIImage(named: "no_image")
                }
                
            }
            
        }
    }

    
    
    
}
