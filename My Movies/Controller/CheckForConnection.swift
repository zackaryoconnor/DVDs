//
//  CheckForConnection.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/7/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

class CheckForConnection {
    
    static let shared = CheckForConnection()
    
    let noConnectionLabel = UILabel(textAlignment: .center)
    
    let searchController = UISearchController(searchResultsController: nil)
    
    func connectionStatusOf(_ controller: UICollectionViewController) {
        firebase.checkForConnectionReference.observe(.value) { (snapshot) in
            if let connected = snapshot.value as? Bool, connected {
                controller.collectionView.isHidden = false
                self.noConnectionLabel.isHidden = true
                controller.navigationItem.searchController?.searchBar.isHidden = false
                
                controller.navigationItem.title = "Search"
                
            } else {
                
                controller.collectionView.isHidden = true
                controller.view.backgroundColor = .systemBackground
                
                let attributedString = NSMutableAttributedString(string: "Cannot connect to the Internet.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)])
                let normalString = NSMutableAttributedString(string: "\n\nYou must connect to WI-Fi or cellular data network to access the search feature.")
                attributedString.append(normalString)
                
                controller.view.addSubview(self.noConnectionLabel)
                self.noConnectionLabel.attributedText = attributedString
                self.noConnectionLabel.isHidden = false
                self.noConnectionLabel.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
                
                controller.navigationItem.searchController?.searchBar.isHidden = true
                controller.navigationItem.title = ""
            }
        }
    }
}
