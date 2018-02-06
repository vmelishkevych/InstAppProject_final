//
//  TagCollectionController.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit


class TagCollectionController: PostsCollectionController {
    
    var tag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // configure search bar
        
        self.searchBar.text = self.tag

        
        
        // fetch Data from Web
        
        fetchDataFromWeb()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Help methods
    
    func fetchDataFromWeb() {
        
        fetchMediasFromWebWithTag()
    }


    // Api methods
    
    func fetchMediasFromWebWithTag() {
        
        guard let token = self.accessToken,
                let tag = self.tag else {
 
            print("error or access denied!!")
            return
        }
        
        AlamofireMethodsApi.fetchMediasWithTag(tag, token: token) { (medias) in
            
            DispatchQueue.main.async {
                
                if let mediasConfirmed = medias {
                    
                    self.searchBar.isHidden = false
                    self.navigationItem.rightBarButtonItem = nil
                    
                    self.mediaArray = mediasConfirmed
                    self.navigationItem.title = "Tag: " + tag
                    self.collectionView!.reloadData()
                    
                    
                    
                } else {
                    
                    self.setRightBarButtonItem(title: "Reload",
                                               action: #selector(self.reload))
                    
                    print("error fetching tag media from Web!!!!!")
                    self.showAllertController(withTitle: "Tag data is not available", andMessage: "Please try to reload tag data again")
                    
                }
            }
         }
    }
    
    // actions
    
    @objc func reload() {
        
        self.fetchMediasFromWebWithTag()
    }

    
    // MARK: UICollectionViewDataSource
    
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photoDictionary = self.photoDictionaries[indexPath.row]
        
        let vc = DetailPhotoViewController()
        vc.modalPresentationStyle = .custom
        
        vc.transitioningDelegate = self
        
        
        
        vc.photo = photoDictionary
        present(vc, animated: true, completion: nil)
        
        
        
        
    }
    */
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let tag = searchBar.text {
            
            searchBar.resignFirstResponder()

                self.tag = tag
                self.fetchMediasFromWebWithTag()
        }
    }
}

