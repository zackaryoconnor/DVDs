//
//  HandleSignout.swift
//  My Movies
//
//  Created by Zackary O'Connor on 5/8/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class HandleSignout {
    
    func signout(completion: () -> ()) {
        let controller = UIViewController()
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError {
            if let errorCode = AuthErrorCode(rawValue: signOutError._code) {
                controller.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
        }
        welcomeController.modalPresentationStyle = .fullScreen
        completion()
    }
}
