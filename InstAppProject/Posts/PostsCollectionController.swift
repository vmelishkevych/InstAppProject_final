//
//  PostsCollectionController.swift
//  InstAppProject
//
//  Created by Torris on 11/27/17.
//  Copyright © 2017 Vasiliy Melishkevych. All rights reserved.
//

import UIKit


class PostsCollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    // define identifiers

    enum CellIdentifier: String {
        case PhotoCollectionCell
        case HeaderView
        case FooterView
    }

    enum ControllerIdentifier: String {
        case TagCollectionController
        case UserCollectionController
    }

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!

    var accessToken: String?

    
    var mediaArray = [Media]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // configure search bar
        searchBar.delegate = self
        self.searchBar.isHidden = true
        
        // configure the collection view
        collectionView.backgroundColor = UIColor.yellow
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateItemSize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Help methods
    
    func updateItemSize() {

        
        let viewWidth = view.bounds.size.width
        
        let desiredItemWidth: CGFloat = 100
        let columns: CGFloat = max(floor(viewWidth / desiredItemWidth), 3)
        let padding: CGFloat = 6
        let itemWidth = floor((viewWidth - (columns + 1) * padding) / columns)
        let itemSize = CGSize(width: itemWidth, height: itemWidth + 30.0)
        
        layout.itemSize = itemSize
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionFootersPinToVisibleBounds = true

        
    }

    func setRightBarButtonItem(title: String, action: Selector?) {
        
        let rightButton = UIBarButtonItem(title: title,
                                          style: .plain,
                                          target: self,
                                          action: action)
        
        self.navigationItem.rightBarButtonItem = rightButton

    
    }
    
    // present alert on view
    
    func showAllertController(withTitle title: String?, andMessage message: String?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        let actionCancel = UIAlertAction(title: "Hide a message", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        
        self.navigationController?.topViewController?.present(alert,
                                                              animated: true,
                                                              completion: nil)
        
    }

    
   
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.PhotoCollectionCell.rawValue,
                                                      for: indexPath) as! PhotoCollectionCell
        
        // Configure the cell
        
        cell.imageView.image = UIImage(named: "no_image")
        let media = self.mediaArray[indexPath.row]
        cell.photo = media
        
        return cell
    }
    
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
   
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
}

