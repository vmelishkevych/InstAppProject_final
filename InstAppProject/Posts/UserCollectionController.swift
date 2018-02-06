//
//  UserCollectionController.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit


class UserCollectionController: PostsCollectionController {

    var isRootController = true
    var user_id: String?
    var userProfile: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        
        // fetch Data from Web
        
        fetchDataFromWeb()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Help methods
    
    
    func fetchDataFromWeb() {
        
        isRootController ? authorizeUser() : updateUserProfile()
    }
    
    
    // Api methods
    
    func authorizeUser() {
        
        let loginController = LoginViewController {(token) in
            
                                            if let tokenString = token?.tokenString {

                                                self.accessToken = tokenString
                                                self.user_id = "self"
                                                self.updateUserProfile()
                                                
                                            } else {
                                                
                                                self.setRightBarButtonItem(title: "Login",
                                                                           action: #selector(self.login))
                                                 print("error or access denied!!")
                                                
                                            }
        }
        
        navigationController?.pushViewController(loginController, animated: false)
    }
    
    
    func updateUserProfile() {

        guard let token = self.accessToken,
            let user_id = self.user_id else {
            
                print("error or access denied!!")
                return
        }
        
        AlamofireMethodsApi.fetchUserCountsWith(user_id: user_id,
                                         token: token) { (userProfile) in
                                        
                                    if let profileConfirmed = userProfile {
                                        
                                        self.userProfile = profileConfirmed
                                        
                                        self.updateUserMedias()
                                        
                                    } else {
                                        
                                        DispatchQueue.main.async {
                                            
                                            self.setRightBarButtonItem(title: "Reload",
                                                                       action: #selector(self.reload))
                                            
                                            print("error fetching user profile from Web!!!!!")
                                            self.showAllertController(withTitle: "User data is not available",
                                                                      andMessage: "Please try to reload user data again")
                                            
                                        }
                                    }
                                            
        }
    }
    
    func updateUserMedias() {
        
        guard let token = self.accessToken,
            let user_id = self.user_id else {
                
                print("error or access denied!!")
                return
        }
        
        AlamofireMethodsApi.fetchUserResentMedia(user_id: user_id,
                                                 token: token) { (medias) in
                                                    
                                        DispatchQueue.main.async {
                                            
                                            if let mediasConfirmed = medias {
                                                
                                                self.mediaArray = mediasConfirmed
                                                
                                                self.searchBar.isHidden = false
                                                
                                                if self.isRootController {
                                                    
                                                    self.setRightBarButtonItem(title: "add Photo",
                                                                               action: #selector(self.addPhoto))
                                                } else {
                                                    
                                                    self.navigationItem.rightBarButtonItem = nil
                                                }
                                                
                                                self.navigationItem.title = self.userProfile?.userName
                                                
                                                self.collectionView?.reloadData()
                                                
                                            } else {
                                                
                                                self.setRightBarButtonItem(title: "Reload",
                                                                           action: #selector(self.reload))
                                                
                                                print("error fetching user profile from Web!!!!!")
                                                self.showAllertController(withTitle: "User data is not available",
                                                                         andMessage: "Please try to reload user data again")
                                            }
                                        }
        }
        
    }

    
    
    // actions
    
    @objc func addPhoto() {
        
        
    }
    
    
    @objc func reload() {
        
        self.updateUserProfile()
    }
    
    
    
    @objc func login() {
        
        self.authorizeUser()
    }
    

   
    
    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            let profileView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                 withReuseIdentifier: CellIdentifier.HeaderView.rawValue,
                                                                                for: indexPath) as! ProfileView
            
            // Configure the view
            
            profileView.userImage.image = UIImage(named: "no_image")
            
            let layer = profileView.userImage.layer
            layer.borderWidth = 1.0
            layer.masksToBounds = false
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = profileView.userImage.frame.height / 2
            profileView.userImage.clipsToBounds = true
            
            profileView.user = self.userProfile
            
            return profileView
            
        case UICollectionElementKindSectionFooter:
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: CellIdentifier.FooterView.rawValue,
                                                                                for: indexPath) as! FooterView
            
            // Configure the view
            
            return footerView

        default:
            fatalError("an unexpected kind of supplementary view")
        }
    }
    
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let tag = searchBar.text {
            
            searchBar.resignFirstResponder()

            self.searchBar.text = nil
            
            let tagsController = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.TagCollectionController.rawValue) as! TagCollectionController

            tagsController.accessToken = self.accessToken
            tagsController.tag = tag
            
            navigationController?.pushViewController(tagsController, animated: true)

            }
    }
}
