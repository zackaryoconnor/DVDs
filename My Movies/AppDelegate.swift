//
//  AppDelegate.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

public func baseNavController(viewController: UIViewController, title: String, searchControllerText: String) -> UIViewController {
    let navigationController = UINavigationController(rootViewController: viewController)
    let searchController = UISearchController(searchResultsController: nil)
    
    navigationController.navigationBar.prefersLargeTitles = true
    
    searchController.searchBar.placeholder = searchControllerText
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.definesPresentationContext = true
    
    viewController.navigationItem.searchController = searchController
    viewController.navigationItem.title = title
    viewController.view.backgroundColor = .systemBackground
    
    return navigationController
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = baseNavController(viewController: MoviesController(), title: "Library", searchControllerText: "Search movies you own...")
        window?.makeKeyAndVisible()
        
        return true
    }

}

