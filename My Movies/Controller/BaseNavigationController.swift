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
        
//
//        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.init(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(.serif) ?? .preferredFontDescriptor(withTextStyle: .largeTitle), size: 16)]
//
        
//        let label: UILabel = {
//            let label = UILabel(text: "navbar", textColor: .blue, fontSize: 14, fontWeight: .heavy, textAlignment: .left, numberOfLines: 1)
//            return label
//        }()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attributes
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
        
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .systemBackground
        
        return navigationController
    }
}

