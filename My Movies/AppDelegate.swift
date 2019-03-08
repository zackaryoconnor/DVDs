//
//  AppDelegate.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit

public func createNavController(viewController: UIViewController, title: String, searchControllerText: String) -> UIViewController {
    
    let navigtionController = UINavigationController(rootViewController: viewController)
    let searchController = UISearchController(searchResultsController: nil)
    
    navigtionController.navigationBar.prefersLargeTitles = true
    navigtionController.navigationBar.tintColor = .black
    
    searchController.searchBar.placeholder = searchControllerText
    searchController.searchBar.tintColor = .black
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.definesPresentationContext = true
    
    viewController.navigationItem.searchController = searchController
    viewController.navigationItem.title = title
    viewController.view.backgroundColor = .white
    
    return navigtionController
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let layout = UICollectionViewFlowLayout()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = createNavController(viewController: MoviesController(collectionViewLayout: layout), title: "My Movies", searchControllerText: "Search movies you own...")
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

