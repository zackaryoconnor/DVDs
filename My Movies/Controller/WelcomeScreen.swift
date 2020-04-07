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

class WelcomeScreen: UIViewController {
    
    // MARK: - views
    let dvdLogo = UIImageView(image: "", cornerRadius: 0)
    let buttonCornerRadius: CGFloat = 12
    
    let welcomeLabel = UILabel(text: "Welcome to DVD's", textColor: .label, fontSize: 36, fontWeight: .bold, textAlignment: .center, numberOfLines: 2)
    let welcomeDescriptionLabel = UILabel(text: "The best way to see what movies and TV Shows you own on DVD or Blu-ray", textColor: .label, fontSize: 17, fontWeight: .regular, textAlignment: .center, numberOfLines: 0)
    
    lazy var logInButton = UIButton(title: "Sign in with email", backgroundColor: .systemBlue, setTitleColor: .white, font: .systemFont(ofSize: 17, weight: .medium), cornerRadius: buttonCornerRadius)
    let signUpButton = UIButton(title: "Don't have an accout? Sign up here", backgroundColor: .clear, setTitleColor: .lightGray, font: .systemFont(ofSize: 14, weight: .regular), cornerRadius: 0)
    
    let googleButton = GIDSignInButton()
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
        view.backgroundColor = .systemBackground
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //        setupWelcomeLabel()
        setupButtons()
    }
    
    
    // MARK: - setup
    fileprivate func setupWelcomeLabel() {
        
        dvdLogo.constrainWidth(constant: 150)
        dvdLogo.clipsToBounds = true
        dvdLogo.contentMode = .scaleAspectFit
        
        let welcomeStack = UIStackView(arrangedSubviews: [
            welcomeLabel,
            welcomeDescriptionLabel
        ], customSpacing: 8, axis: .vertical)
        
        [dvdLogo, welcomeStack].forEach({ view.addSubview($0) })
        
        welcomeStack.centerInSuperview()
        welcomeStack.constrainWidth(constant: view.frame.width - 16 * 2)
        
        dvdLogo.centerXInSuperview()
        dvdLogo.anchor(top: nil, leading: nil, bottom: welcomeStack.topAnchor, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    
    fileprivate func setupButtons() {
        logInButton.constrainHeight(constant: 54)
        logInButton.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        
        googleButton.style = .wide
        googleButton.colorScheme = .light
        googleButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        
        let logInButtonsStackview = UIStackView(arrangedSubviews: [
            googleButton,
            logInButton,
            UIView(),
            signUpButton], customSpacing: 12)
        view.addSubview(logInButtonsStackview)
        logInButtonsStackview.anchor(top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    
    // MARK: - @objc methods
    @objc fileprivate func handleLogIn() {
        present(LogInController(), animated: true, completion: nil)
    }
    
    
    @objc func googleLogin() {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    @objc fileprivate func handleSignUpButtonPressed() {
        present(SignUpController(), animated: true, completion: nil)
    }
}




    // MARK: - Google sign in Delegate
extension WelcomeScreen: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
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
                print("logged in")
                let vc = DvdsController()
                vc.collectionView.reloadData()
                vc.checkIfUserHasMovies()
                self.presentingViewController?.dismiss(animated: true)
            }
        }
    }
    
}
