//
//  BaseNavigationController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/7/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

struct BaseNavigationController {
    
    static let shared = BaseNavigationController()
    
    
    
    func controller(viewController: UIViewController, title: String, searchControllerText: String? = nil, searchControllerPlaceholderText: String? = nil) -> UIViewController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = searchControllerText
        searchController.searchBar.placeholder = searchControllerPlaceholderText
        
        viewController.navigationItem.searchController = searchController
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemBackground
        
        return navigationController
    }
}

