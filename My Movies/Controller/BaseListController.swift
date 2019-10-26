//
//  BaseListController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 3/28/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        collectionView.backgroundColor = .systemBackground
    }
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

