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
    
    // MARK: - views
    let welcomeLabel = UILabel(text: "Login with email...", textColor: .label, fontSize: 36, fontWeight: .bold, textAlignment: .left, numberOfLines: 0)
    
    let emailTextField = UITextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next, autocorrectionType: .no)
    let emailSeperatorView = UIView(backgroundColor: .lightGray)
    
    let passwordTextField = UITextField(placeholder: "Password", keyboardType: .default, returnKeyType: .go, autocorrectionType: .no)
    let passwordSeperatorView = UIView(backgroundColor: .lightGray)
    
    let logInButton = UIButton(title: "Log In", backgroundColor: .systemBlue, setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: 12)
    let signUpButton = UIButton(title: "Don't have an accout? Tap here.", backgroundColor: .clear, setTitleColor: .lightGray, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
    
    
    // MARK: - vars and lets
    let moviesController = DvdsController()
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupWelcomeLabel()
        setupTextFields()
        setupButtons()
        setupGestures()
    }
    
    
    // MARK: - setup
    fileprivate func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 64, left: 16, bottom: 0, right: 16))
    }
    
    
    let dividerHeight: CGFloat = 0.5
    fileprivate func setupTextFields() {
        emailSeperatorView.constrainHeight(constant: dividerHeight)
        emailTextField.constrainHeight(constant: 46)
        emailTextField.autocapitalizationType = .none
        
        passwordSeperatorView.constrainHeight(constant: dividerHeight)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.constrainHeight(constant: 46)
        passwordTextField.autocapitalizationType = .none
        
        let textFieldsStackview = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [emailTextField, emailSeperatorView], customSpacing: -4),
            UIStackView(arrangedSubviews: [passwordTextField, passwordSeperatorView], customSpacing: -4)
            ], customSpacing: 42)
        view.addSubview(textFieldsStackview)
        textFieldsStackview.centerInSuperview()
        textFieldsStackview.constrainWidth(constant: view.frame.width - 32)
    }
    
    
    fileprivate func setupButtons() {
        logInButton.constrainHeight(constant: 54)
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [
            logInButton,
            signUpButton], customSpacing: 4)
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    
    fileprivate func setupGestures() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        swipeGesture.direction = [.up, .down]
        
        view.addGestureRecognizer(swipeGesture)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard)))
    }
    
    
    // MARK: - @objc methods
    @objc func handleLogIn() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                
                return
            } else if Auth.auth().currentUser?.uid == Auth.auth().currentUser?.uid {
                let vc = DvdsController()
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                    vc.collectionView.reloadData()
                    vc.checkIfUserHasMovies()
                })
            }
        }
        
    }
    
    
    @objc fileprivate func handleSignUpButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        let vc = DvdsController()
        vc.collectionView.reloadData()
        vc.checkIfUserHasMovies()
        present(SignUpController(), animated: true)
    }
    
    
    @objc fileprivate func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }
    
}




// MARK: - textFieldDelegate
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
