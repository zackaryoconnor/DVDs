//
//  AppDelegate.swift
//  My Movies
//
//  Created by Zackary O'Connor on 1/18/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

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
        Database.database().isPersistenceEnabled = true
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = baseNavController(viewController: DvdsController(), title: "Library", searchControllerText: "Search movies you own...")
        window?.makeKeyAndVisible()
        
        return true
    }
}




extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                UIViewController().displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    UIViewController().displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                
                return
            }
        }
    }
}




