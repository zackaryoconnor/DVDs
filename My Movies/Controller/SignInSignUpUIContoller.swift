//
//  SignInSignUpUIContoller.swift
//  My Movies
//
//  Created by Zackary O'Connor on 4/24/20.
//  Copyright © 2020 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class SignInSignUpUIContoller: UIViewController {
    
    // MARK: - views
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let welcomeLabel = UILabel(fontSize: 36, fontWeight: .bold)
    
    let emailTextField = UITextField(placeholder: "Email", keyboardType: .emailAddress, returnKeyType: .next, autocorrectionType: .no)
    let emailSeperatorView = UIView(backgroundColor: .lightGray)
    
    let passwordTextField = UITextField(placeholder: "Password", keyboardType: .default, returnKeyType: .go, autocorrectionType: .no)
    let passwordSeperatorView = UIView(backgroundColor: .lightGray)
    
    let signInSignUpButton: UIButton = {
        let button = UIButton(setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: 12)
        button.constrainHeight(constant: 54)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(title: "Forgot Password", backgroundColor: .clear, setTitleColor: .tertiaryLabel, font: .systemFont(ofSize: 14), cornerRadius: 0)
        button.constrainHeight(constant: 36)
        button.addTarget(self, action: #selector(handleForgotPasswordButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.constrainHeight(constant: 36)
        return view
    }()
    
    let needOrAlreadyHaveAccountButton: UIButton = {
        let button = UIButton(backgroundColor: .clear, setTitleColor: .lightGray, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
        button.constrainHeight(constant: 36)
        return button
    }()
    
    
    // MARK: - vars and lets
    let dividerHeight: CGFloat = 0.5
    let textFieldHeight: CGFloat = 46
    
    
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
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 76, left: padding, bottom: 0, right: padding))
    }
    
    
    fileprivate func setupTextFields() {
        emailSeperatorView.constrainHeight(constant: dividerHeight)
        emailTextField.constrainHeight(constant: textFieldHeight)
        emailTextField.autocapitalizationType = .none
        
        passwordSeperatorView.constrainHeight(constant: dividerHeight)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.constrainHeight(constant: textFieldHeight)
        passwordTextField.autocapitalizationType = .none
        
        let textFieldsStackview = UIStackView(arrangedSubviews: [UIStackView(arrangedSubviews: [emailTextField, emailSeperatorView], customSpacing: -4, distribution: .fillProportionally),
                                                                 UIStackView(arrangedSubviews: [passwordTextField, passwordSeperatorView], customSpacing: -4, distribution: .fillProportionally)
        ], customSpacing: 42)
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        [textFieldsStackview].forEach { scrollView.addSubview($0) }
        
        textFieldsStackview.centerInSuperview()
        textFieldsStackview.constrainWidth(constant: view.frame.width - 32)
    }
    
    
    fileprivate func setupButtons() {
        let logInButtonsStackview = UIStackView(arrangedSubviews: [signInSignUpButton,
                                                                   forgotPasswordButton,
                                                                   spacer,
                                                                   needOrAlreadyHaveAccountButton], customSpacing: 8, distribution: .fillProportionally)
        
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: padding, bottom: padding, right: padding))
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
    
    @objc func handleForgotPasswordButtonPressed() {
        
        guard let email = emailTextField.text, email != "" else {
            displayAlertController(title: "Please enter email.", message: "Enter your email address and we will send you instructions to reset your password.", buttonTitle: "Ok")
            return
        }
        
        resetPassword(email: email)
    }
     
    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                self.displayAlertController(title: "Success!", message: "We've sent you instructions on how to reset your password.", buttonTitle: "Awesomesauce!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.presentingViewController?.dismiss(animated: true)
                }
            } else {
                self.displayAlertController(title: "Oops!", message: "Please check that your email address is correct.", buttonTitle: "Oh, my bad.")
                error?.localizedDescription
                print(error?.localizedDescription)
            }
        }
    }
    
}




extension SignInSignUpUIContoller: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            scrollView.setContentOffset(CGPoint(x: 0, y: 42), animated: true)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
