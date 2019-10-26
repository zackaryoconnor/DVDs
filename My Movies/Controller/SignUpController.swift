//
//  SignUpController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 6/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - views
    let welcomeLabel = UILabel(text: "Welcome to My Movies...", textColor: .label, fontSize: 54, fontWeight: .black, textAlignment: .left, numberOfLines: 0)
    
    let emailTextField = UITextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next, autocorrectionType: .no)
    let emailSeperatorView = UIView(backgroundColor: .lightGray)
    
    let passwordTextField = UITextField(placeholder: "Password", keyboardType: .default, returnKeyType: .go, autocorrectionType: .no)
    let passwordSeperatorView = UIView(backgroundColor: .lightGray)
    
    let signUpButton = UIButton(title: "Sign Up", backgroundColor: .systemBlue, setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: 12)
    let loginButton = UIButton(title: "Already have an accout? Tap here.", backgroundColor: .clear, setTitleColor: .secondaryLabel, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        isModalInPresentation = true
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
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 46, left: 16, bottom: 0, right: 16))
    }
    
    let dividerHeight: CGFloat = 0.5
    fileprivate func setupTextFields() {
        emailSeperatorView.constrainHeight(constant: dividerHeight)
        emailTextField.constrainHeight(constant: 46)
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.isSecureTextEntry = true
        passwordSeperatorView.constrainHeight(constant: dividerHeight)
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
        signUpButton.layer.cornerRadius = 12
        signUpButton.constrainHeight(constant: 54)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogInButtonPressed), for: .touchUpInside)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [
            signUpButton,
            loginButton
            ], customSpacing: 4)
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
    @objc fileprivate func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, error) in
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                
                return
            }
            

            guard let uid = Auth.auth().currentUser?.uid else { return }
            firebaseReference.child(firebaseUsersReference).child(uid).updateChildValues(["email": email])
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleLogInButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
}




// MARK: - textFieldDelegate
extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            handleSignUp()
        }
        return true
    }
}



