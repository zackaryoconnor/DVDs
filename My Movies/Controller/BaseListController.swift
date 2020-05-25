//
//  BaseListController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 3/28/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class BaseListController: UICollectionViewController {
    
    static let shared = BaseListController()
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesSearchBarWhenScrolling = false

        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isUserInteractionEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.allowsSelection = false
        
        
        checkIfUserIsLoggedIn()
    }


    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let vc = WelcomeScreen()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
                return
            }
        }
    }
    
    

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




//extension BaseListController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {}
//
//    func searchBarIsEmpty() -> Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
//
//
//    func isFiltering() -> Bool {
//        return searchController.isActive && !searchBarIsEmpty()
//    }
//}




//extension BaseListController: UISearchBarDelegate {}
