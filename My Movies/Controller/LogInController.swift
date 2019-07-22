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
    
    let welcomeLabel = UILabel(text: "Welcome back...", textColor: .black, fontSize: 54, fontWeight: .black, textAlignment: .left, numberOfLines: 2)
    let emailTextField = UITextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next, autocorrectionType: .no)
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 0.5)
        return view
    }()
    let passwordTextField = UITextField(placeholder: "Password", keyboardType: .default, returnKeyType: .go, autocorrectionType: .no)
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(constant: 0.5)
        return view
    }()
    let logInButton = UIButton(title: "Log In", backgroundColor: .black, setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: 12)
    let signUpButton = UIButton(title: "Don't have an accout? Tap here.", backgroundColor: .clear, setTitleColor: .lightGray, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    
    fileprivate func setupViews() {
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 46, left: 16, bottom: 0, right: 16))
        
        
        passwordTextField.isSecureTextEntry = true
        
        let textFieldsStackview = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [emailTextField, emailSeperatorView], customSpacing: 8),
            UIStackView(arrangedSubviews: [passwordTextField, passwordSeperatorView], customSpacing: 8)
            ], customSpacing: 42)
        view.addSubview(textFieldsStackview)
        textFieldsStackview.centerInSuperview()
        textFieldsStackview.constrainWidth(constant: view.frame.width - 32)
        
        
        logInButton.constrainHeight(constant: 54)
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [logInButton, signUpButton], customSpacing: 4)
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        swipeGesture.direction = [.up, .down]
        view.addGestureRecognizer(swipeGesture)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard)))
    }
    
    
    @objc func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error as Any)
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
    
    
    @objc fileprivate func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }
    
}




extension LogInController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            handleLogIn()
        }
        return true
    }
}
