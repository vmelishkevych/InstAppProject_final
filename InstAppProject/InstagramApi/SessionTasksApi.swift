//
//  SessionTasksApi.swift
//  InstAppProject
//
//  Created by Torris on 11/12/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import Foundation
import UIKit

class SessionTasksApi {
     
    
    static func imageFor(stringURL: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        // get image from Web
        
        guard let url = URL(string: stringURL) else {
            print("Error while fetching url from urlString")
            completion(nil)
            return
        }
        
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            
            guard error == nil else {
                print("Error while fetching data from Web: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let localFileConfirmed = localFile else {
                print("Error: localFile is nil for data that was received from Web")
                
                if let responseConfirmed = response {
                    debugPrint("Here`s the response: \(responseConfirmed)")
                }
                completion(nil)
                return
            }
            
            
            
            guard let dataConfirmed = try? Data.init(contentsOf: localFileConfirmed) else {
                print("Error while fetching data from local file")
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: dataConfirmed) else {
                print("Error while fetching image from data")
                completion(nil)
                return
            }
            
            
            completion(image)
            
        }
        
        task.resume()
    }
    
}
