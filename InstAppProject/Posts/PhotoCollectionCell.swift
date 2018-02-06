//
//  PhotoCollectionCell.swift
//  InstAppProject
//
//  Created by Torris on 11/4/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit



class PhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    
    var photo: Media? {
     
        didSet {
            
            if let setMedia = photo {
                
                //set likes
                let likes: String
                
                if let count = setMedia.likes {
                    likes = String(count)
                } else {
                    likes = "no data"
                }
                
                likesCount.text = "❤️ " + likes + " likes"
                
                
                // set photo
                
                if let stringURL = setMedia.takenThumbnail {
                    
                    SessionTasksApi.imageFor(stringURL: stringURL) { (image) in
                        
                        DispatchQueue.main.async {
                            self.imageView.image = image ?? UIImage(named: "no_image")
                        }
                    }
                } else {
                    
                    self.imageView.image = UIImage(named: "no_image")
                }
                
            }
            
        }
    }
    
}
