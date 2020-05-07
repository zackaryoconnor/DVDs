//
//  SigninSignUpUIContoller.swift
//  My Movies
//
//  Created by Zackary O'Connor on 4/24/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class SigninSignUpUIContoller: UIViewController, UITextFieldDelegate {
   
    // MARK: - views
    let welcomeLabel = UILabel(text: "", textColor: .label, fontSize: 36, fontWeight: .bold, textAlignment: .left, numberOfLines: 0)
    
    let emailTextField = UITextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next, autocorrectionType: .no)
    let emailSeperatorView = UIView(backgroundColor: .lightGray)

    let passwordTextField = UITextField(placeholder: "Password", keyboardType: .default, returnKeyType: .go, autocorrectionType: .no)
    let passwordSeperatorView = UIView(backgroundColor: .lightGray)

    let signInSignUpButton = UIButton(title: "", backgroundColor: .systemBlue, setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: 12)
    let needOrAlreadyHaveAccountButton = UIButton(title: "", backgroundColor: .clear, setTitleColor: .lightGray, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
    
    
    // MARK: - vars and lets
    let dividerHeight: CGFloat = 0.5
    let textFieldHeight: CGFloat = 46
    
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
    func setupUI(welcomeLabelText: String, signInSignUpButtonText: String, signInSignUpButtonSelector: Selector, needOrAlreadyHaveAccountButtonText: String, needOrAlreadyHaveAccountButtonSelector: Selector) {
        
        welcomeLabel.text = welcomeLabelText
        
        needOrAlreadyHaveAccountButton.setTitle(needOrAlreadyHaveAccountButtonText, for: .normal)
        needOrAlreadyHaveAccountButton.addTarget(self, action: needOrAlreadyHaveAccountButtonSelector, for: .touchUpInside)
        
        signInSignUpButton.setTitle(signInSignUpButtonText, for: .normal)
        signInSignUpButton.addTarget(self, action: signInSignUpButtonSelector, for: .touchUpInside)
    }
    
    
    fileprivate func setupWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 64, left: padding, bottom: 0, right: padding))
    }
    
    
    
    fileprivate func setupTextFields() {
        emailSeperatorView.constrainHeight(constant: dividerHeight)
        emailTextField.constrainHeight(constant: textFieldHeight)
        emailTextField.autocapitalizationType = .none

        passwordSeperatorView.constrainHeight(constant: dividerHeight)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.constrainHeight(constant: textFieldHeight)
        passwordTextField.autocapitalizationType = .none

        let textFieldsStackview = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [emailTextField, emailSeperatorView], customSpacing: -4, distribution: .fillProportionally),
            UIStackView(arrangedSubviews: [passwordTextField, passwordSeperatorView], customSpacing: -4, distribution: .fillProportionally)
            ], customSpacing: 42)
        view.addSubview(textFieldsStackview)
        textFieldsStackview.centerInSuperview()
        textFieldsStackview.constrainWidth(constant: view.frame.width - 32)
    }
    
    
    fileprivate func setupButtons() {
        signInSignUpButton.constrainHeight(constant: 54)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [signInSignUpButton,
                                                                   needOrAlreadyHaveAccountButton], customSpacing: 16)
        
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding))
    }
    
    
    fileprivate func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard))
        swipeGesture.direction = [.up, .down]
        
        [swipeGesture, tapGesture].forEach({ view.addGestureRecognizer($0) })
    }
    
    
    // MARK: - @objc methods
    @objc fileprivate func handleTapToDismissKeyboard() {
        view.endEditing(true)
    }
    
}
