//
//  WelcomeScreen.swift
//  My Movies
//
//  Created by Zackary O'Connor on 11/19/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

let buttonCornerRadius: CGFloat = 12
let buttonHeight: CGFloat = 54

class WelcomeScreen: UIViewController {
    
    // MARK: - views
    let welcomeLabel = UILabel(text: "Welcome to DVDs", textColor: .label, fontSize: 36, fontWeight: .bold, textAlignment: .center, numberOfLines: 2)
    
    let welcomeDescriptionLabel = UILabel(text: "Easily keep track of the Movies and TV Shows you own on DVD or Blu-ray.", textAlignment: .center, numberOfLines: 0)
    
    lazy var googleButton = customGoogleButton
    
    let appleButton: UIButton = {
        let button = UIButton(title: "Sign in with Apple", backgroundColor: .systemOrange , setTitleColor: .label, font: .systemFont(ofSize: 17, weight: .regular), cornerRadius: buttonCornerRadius)
        button.constrainHeight(constant: buttonHeight)
        return button
    }()
    
    let orLabel = UILabel(text: "- or -", textColor: .tertiaryLabel, fontSize: 14, textAlignment: .center)
    
    lazy var signInWithEmailButton: UIButton = {
        let button = UIButton(title: "Sign in with email", backgroundColor: .clear , setTitleColor: .secondaryLabel, font: .systemFont(ofSize: 17, weight: .regular), cornerRadius: buttonCornerRadius)
        button.constrainHeight(constant: 36)
        return button
    }()
    
    let spacer: UIView = {
        let view = UIView()
        view.constrainHeight(constant: 36)
        return view
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(title: "Don't have an accout? Sign up here", backgroundColor: .clear, setTitleColor: .tertiaryLabel, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
        button.constrainHeight(constant: 42)
        return button
    }()
    
    
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        view.backgroundColor = .systemBackground
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        setupWelcomeLabel()
        setupButtons()
    }
    
    
    // MARK: - setup
    fileprivate func setupWelcomeLabel() {
        
        let welcomeStackView = UIStackView(arrangedSubviews: [
            welcomeLabel,
            welcomeDescriptionLabel
        ], customSpacing: 8, axis: .vertical)
        
        [welcomeStackView].forEach({ view.addSubview($0) })
        
//        welcomeStackView.centerInSuperview()
//        welcomeStackView.constrainWidth(constant: view.frame.width - 16 * 2)
        welcomeStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 142, left: padding, bottom: 0, right: padding))
    }
    
    
    fileprivate func setupButtons() {
        signInWithEmailButton.constrainHeight(constant: buttonHeight)
        signInWithEmailButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        
        googleButton.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [
                                                    googleButton,
                                                    appleButton,
                                                    UIView(),
                                                    orLabel,
                                                    signInWithEmailButton,
                                                    spacer,
                                                    signUpButton], customSpacing: 8, distribution: .equalSpacing)
        
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: padding, bottom: 8, right: padding))
    }
    
    
    // MARK: - @objc methods
    @objc fileprivate func handleGoogleLogin() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @objc fileprivate func handleLogIn() {
        present(SignInController(), animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handleSignUpButtonPressed() {
        present(SignUpController(), animated: true, completion: nil)
    }
}




// MARK: - Google sign in Delegate
extension WelcomeScreen: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error.localizedDescription)
            if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
            }
            
            return
        }
        
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                return
                
            } else {
                self.presentingViewController?.dismiss(animated: true, completion: {
                    dvdsController.collectionView.reloadData()
                    dvdsController.checkIfUserHasDvds()
                })
            }
        }
    }
    
}
