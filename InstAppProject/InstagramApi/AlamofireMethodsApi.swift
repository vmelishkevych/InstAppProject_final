//
//  AlamofireMethodsApi.swift
//  InstAppProject
//
//  Created by Torris on 11/15/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireMethodsApi {
    
    
    
    // Fetch tags media
    
    class func fetchMediasWithTag(_ tag: String, token: String, callback: @escaping ([Media]?) -> Void) {
        
        let escapedString = tag.replacingOccurrences(of: " ", with: "")
        
        request( "https://api.instagram.com/v1/tags/\(escapedString)/media/recent?access_token=\(token)",
                 method: HTTPMethod.get,
                 parameters: nil,
                 encoding: URLEncoding.default,
                 headers: nil).responseJSON(queue: DispatchQueue.global(qos: .utility),
                                            options: JSONSerialization.ReadingOptions.mutableContainers) { (response) in
  
                    
                    switch response.result {
                    case .success(let value):
                       
                        print("response result: \(response.result.isSuccess)")
                        print("response: \(response.description)")

                        
                        guard let jsonConfirmed = value as? [String:Any] else {
                            print("Error: malformed data in parsed response.result of MediaTags")
                            callback(nil)
                            return
                        }
                        
                        
                        guard let mediaDicts = jsonConfirmed["data"] as? [[String:Any]] else {
                            print("Error: malformed data in parsed jsonConfirmed of MediaTags")
                            callback(nil)
                            return
                        }
                        
                        self.populateMediaWith(token: token, json: mediaDicts, callback: callback)
 
                    case .failure(let error):
                        
                        print("response result: \(response.result.isSuccess)")
                        print("error!!!: \(error)")
                        callback(nil)
                    }
        }
     }
    
    // Fetch user resent media
    
    class func fetchUserResentMedia(user_id: String, token: String, callback: @escaping ([Media]?) -> Void) {
        
        request( "https://api.instagram.com/v1/users/\(user_id)/media/recent/?access_token=\(token)",
            method: HTTPMethod.get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil).responseJSON(queue: DispatchQueue.global(qos: .utility),
                                       options: JSONSerialization.ReadingOptions.mutableContainers) { (response) in
                                        
                                        
                                        switch response.result {
                                        case .success(let value):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("response: \(response.description)")
                                            
                                            
                                            guard let jsonConfirmed = value as? [String:Any] else {
                                                print("Error: malformed data in parsed response.result of MediaTags")
                                                callback(nil)
                                                return
                                            }
                                            
                                            
                                            guard let mediaDicts = jsonConfirmed["data"] as? [[String:Any]] else {
                                                print("Error: malformed data in parsed jsonConfirmed of MediaTags")
                                                callback(nil)
                                                return
                                            }
                                            
                                            self.populateMediaWith(token: token, json: mediaDicts, callback: callback)
                                            
                                        case .failure(let error):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("error!!!: \(error)")
                                            callback(nil)
                                        }
        }
    }
    

    
    
    // populate medias data
    
    private class func populateMediaWith(token: String, json: [[String: Any]], callback: @escaping ([Media]?) -> Void) {
        
        var mediaArray = [Media]()

        
        for mediaDict in json {
            
            let media = Media()
            
            // set comments
            if let media_id = mediaDict["id"] as? String {
                
                self.fetchCommentsWith(media_id: media_id,
                                              token: token,
                                              callback: { (comments) in
                                                
                                                media.comments = comments
                    })
                }
            
            
            // set taken photo
            if let imagesDictionary = mediaDict["images"] as? [String:Any],
                let imageData = imagesDictionary["standard_resolution"] as? [String:Any],
                let urlString = imageData["url"] as? String {
                
                media.takenPhoto = urlString
                
            }

            
            // set taken thumbnail
            if let imagesDictionary = mediaDict["images"] as? [String:Any],
                let imageData = imagesDictionary["thumbnail"] as? [String:Any],
                let urlString = imageData["url"] as? String {
                
                media.takenThumbnail = urlString
                
            }

            // set user profile
            if let userDictionary = mediaDict["user"] as? [String:Any] {
            
                // set user_id
                if let id = userDictionary["id"] as? String {
                    
                    media.user_id = id
                }
            
            // set user name
                if let name = userDictionary["username"] as? String {
                    
                    media.userName = name
                }
                
            // set user avatar
                if let avatarURL = userDictionary["profile_picture"] as? String {
                    
                    media.avatarURL = avatarURL
                }
            }
            
            
            // set creation time
            if let time = mediaDict["created_time"] as? String {
                
                media.time = time
            }
            
            // set likes count
            if let likesDictionary = mediaDict["likes"] as? [String:Any],
                let count = likesDictionary["count"] as? Int {
                
                media.likes = count
            }
            
            
            mediaArray.append(media)
        }

        
        callback(mediaArray)
    }

    
     // fetch comments data
    private class func fetchCommentsWith(media_id: String, token: String, callback: @escaping ([Comment]) -> Void) {
        
        request( "https://api.instagram.com/v1/media/\(media_id)/comments?access_token=\(token)",
            method: HTTPMethod.get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil).responseJSON(queue: DispatchQueue.global(qos: .utility),
                                       options: JSONSerialization.ReadingOptions.mutableContainers) { (response) in
                                        
                                        switch response.result {
                                        case .success(let value):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("response: \(response.description)")
                                            
                                            guard let jsonConfirmed = value as? [String:Any] else {
                                                print("Error: malformed data in parsed response.result of Comments")
                                                return
                                            }
                                            
                                            guard let commentsArray = jsonConfirmed["data"] as? [[String:Any]] else {
                                                print("Error: malformed data in parsed jsonConfirmed of Comments")
                                                return
                                            }
                                            
                                            self.populateCommentsData(json: commentsArray, callback: callback)

                                        
                                        case .failure(let error):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("error!!!: \(error)")
                                        }
        }
    }
    
    // populate comments data
    
    private class func populateCommentsData(json: [[String: Any]], callback: @escaping ([Comment]) -> Void) {
        
        var comments = [Comment]()
        
        for commentDict in json {
            
            let comment = Comment(commentDict: commentDict)
            comments.append(comment)
        }
        
        callback(comments)
    }
    
    
    // fetch user data
    
    class func fetchUserCountsWith(user_id: String, token: String, callback: @escaping (User?) -> Void) {
        
        request( "https://api.instagram.com/v1/users/\(user_id)/?access_token=\(token)",
            method: HTTPMethod.get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil).responseJSON(queue: DispatchQueue.global(qos: .utility),
                                       options: JSONSerialization.ReadingOptions.mutableContainers) { (response) in
                                        
                                        switch response.result {
                                        case .success(let value):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("response: \(response.description)")
                                            
                                            guard let jsonConfirmed = value as? [String:Any] else {
                                                print("Error: malformed data in parsed response.result of Comments")
                                                return
                                            }
                                            
                                            guard let userDict = jsonConfirmed["data"] as? [String:Any] else {
                                                print("Error: malformed data in parsed jsonConfirmed of Comments")
                                                return
                                            }
                                            
                                            self.populateUserCounts(json: userDict,
                                                                    callback: callback)
                                            
                                        case .failure(let error):
                                            
                                            print("response result: \(response.result.isSuccess)")
                                            print("error!!!: \(error)")
                                            callback(nil)
                                        }
        }
    }
    
    // populate user counts
    
    private class func populateUserCounts(json: [String: Any], callback: @escaping (User?) -> Void) {
     
        
        var user = User()
        
        // set user_id
        
        if let id = json["id"] as? String {
            
            user.user_id = id
        }
        
        // set user name
        if let name = json["username"] as? String {
            
            user.userName = name
        }
        
        // set user avatar
        if let avatarURL = json["profile_picture"] as? String {
            
            user.avatarURL = avatarURL
        }

        
        
        // set user counts
        if let userCounts = json["counts"] as? [String:Any] {
            
            // set media counts
            if let post = userCounts["media"] as? Int {
                
                user.post = post
            }
            
            // set followers count
            if let followers = userCounts["follows"] as? Int {
                
                user.followers = followers
            }
            
            // set followed_by count
            if let followed_by = userCounts["followed_by"] as? Int {
                
                user.follows = followed_by
            }
        }
        
        callback(user)

    }
    
    
    
    
    
    
    
    
    
    
    
    
}
