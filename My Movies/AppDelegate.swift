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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = baseNavController(viewController: DvdsController(), title: "Library", searchControllerText: "Search movies you own...")
        window?.rootViewController = BaseNavigationController.shared.controller(viewController: DvdsController(), title: "Library", searchControllerPlaceholderText: "Search movies you own...")
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type == "com.zackaryoconnor.My-Movies.SearchAction" {
            let addNewDvdController = AddNewDvdController()
//            let searchController = baseNavController(viewController: addNewDvdController, title: "Search", searchControllerText: "")
            let searchController = BaseNavigationController.shared.controller(viewController: addNewDvdController, title: "Search", searchControllerPlaceholderText: "")
            window?.rootViewController?.present(searchController, animated: true, completion: {
                addNewDvdController.searchController.isActive = true
                DispatchQueue.main.async {
                    addNewDvdController.searchController.searchBar.becomeFirstResponder()
                }
            })
            
        } else if shortcutItem.type == "com.zackaryoconnor.My-Movies.ChangeAppIcon" {
            //            change app icon...
                        let changeAppIconController = UINavigationController(rootViewController: ChangeAppIconController())
                        changeAppIconController.navigationBar.prefersLargeTitles = true
                        changeAppIconController.navigationItem.title = "Change App Icon"
                        window?.rootViewController?.present(changeAppIconController, animated: true)
            
        } else if shortcutItem.type == "com.zackaryoconnor.My-Movies.ShareAction" {
            //            share app...
        }
        
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




