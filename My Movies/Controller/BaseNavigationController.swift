//
//  BaseNavigationController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/7/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

struct BaseNavigationController {
    
//    static let shared = BaseNavigationController()
    
    static func controller(_ viewController: UIViewController, title: String, searchControllerPlaceholderText: String?) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        
        
//        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemBackground
        
        return navigationController
    }
}

