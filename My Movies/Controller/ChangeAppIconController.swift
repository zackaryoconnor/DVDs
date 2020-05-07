//
//  ChangeAppIconController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 4/9/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit

class ChangeAppIconController: UIViewController {
    
    let messageLabel = UILabel(text: "Change app icon", textColor: .label, fontSize: 32, fontWeight: .medium, textAlignment: .left)
    
    let lightIcon = UIButton(type: .custom)
    let darkIcon = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        
        setupLabel()
        setupButtons()
    }
    
    private func setupLabel() {
        view.addSubview(messageLabel)
        messageLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, padding: .init(top: 32, left: 16, bottom: 0, right: 0))
    }
    
    
    private func setupButtons() {
        let buttonSize: CGFloat = 124
        let buttonCornerRadius: CGFloat = 8
        lightIcon.constrainWidth(constant: buttonSize)
        lightIcon.constrainHeight(constant: buttonSize)
        lightIcon.setImage(UIImage(named: "app_icon.png"), for: .normal)
        lightIcon.contentMode = .scaleAspectFit
        lightIcon.layer.cornerRadius = buttonCornerRadius
        lightIcon.clipsToBounds = true
        
        darkIcon.constrainWidth(constant: buttonSize)
        darkIcon.constrainHeight(constant: buttonSize)
        darkIcon.setImage(UIImage(named: "dark_app_icon.png"), for: .normal)
        darkIcon.contentMode = .scaleAspectFit
        darkIcon.layer.cornerRadius = buttonCornerRadius
        darkIcon.clipsToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [lightIcon,
                                                   darkIcon], customSpacing: 32, axis: .horizontal, distribution: .fillEqually)
        
        view.addSubview(stack)
        stack.centerInSuperview()
    }
    
    
    func setAppIcon(_ named: String?) {
        UIApplication.shared.setAlternateIconName(named) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
