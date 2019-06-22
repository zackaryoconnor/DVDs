//
//  LogInController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 6/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    
    
    let welcomeLabel: UILabel = {
        let label = UILabel(text: "Welcome back...", textColor: .black, fontSize: 54, fontWeight: .black, textAlignment: .left
            , numberOfLines: 0)
        return label
    }()
    
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        // change to email keyboard
        return textField
    }()
    
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 0.5)
        return view
    }()
    
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 0.5)
        return view
    }()
    
    
    let logInButton: UIButton = {
        let button = UIButton(title: "Log In")
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.constrainHeight(constant: 54)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton(title: "Don't have an accout? Tap here.")
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 46, left: 16, bottom: 0, right: 16))
        
        let emailStackview = UIStackView(arrangedSubviews: [
            emailTextField,
            emailSeperatorView
            ], customSpacing: 8)
//        emailStackview.axis = .vertical
        
        let passwordStackview = UIStackView(arrangedSubviews: [
            passwordTextField,
            passwordSeperatorView
            ], customSpacing: 8)
//        passwordStackview.axis = .vertical
        
        let textFieldsStackview = UIStackView(arrangedSubviews: [
            emailStackview,
            passwordStackview
            ], customSpacing: 42)
        view.addSubview(textFieldsStackview)
        textFieldsStackview.centerInSuperview()
//        textFieldsStackview.axis = .vertical
        textFieldsStackview.constrainWidth(constant: view.frame.width - 32)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [
            logInButton,
            signUpButton
            ], customSpacing: 4)
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
//        logInButtonsStackview.axis = .vertical
    }
    
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleSignUpButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        present(SignUpController(), animated: true, completion: nil)
    }
    
}




extension UITextFieldDelegate {}
