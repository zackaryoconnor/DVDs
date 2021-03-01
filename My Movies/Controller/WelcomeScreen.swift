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
import CryptoKit
import AuthenticationServices

let buttonCornerRadius: CGFloat = 12
let buttonHeight: CGFloat = 54

class WelcomeScreen: UIViewController {
    
    // MARK: - views
    let welcomeLabel = UILabel(text: "Welcome to DVDs", textColor: .label, fontSize: 36, fontWeight: .bold, textAlignment: .center, numberOfLines: 2)
    
    let welcomeDescriptionLabel = UILabel(text: "Easily keep track of the Movies and TV Shows you own on DVD or Blu-ray.", textAlignment: .center, numberOfLines: 0)
    
    lazy var googleButton = googleSignInButton
    
    lazy var appleButton = appleSignInButton
    
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
        
        appleButton.addTarget(self, action: #selector(startSignInWithAppleFlow), for: .touchUpInside)
        
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
    
    
    
    
    
    
    
    
    // sign in with apple
    
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    
    
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    @objc func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // end sign in with apple
    
    
    
    
    
    
    
    
    
    
    
    
    
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











// apple

@available(iOS 13.0, *)
extension WelcomeScreen: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let displayName = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                firebase.databaseReference.child(firebase.usersReference).child(uid).updateChildValues(["email" : email]) { (error, _) in
                    
                    if let error = error {
                        print(error)
                    } else {
                        self.presentingViewController?.dismiss(animated: true, completion: {
                            dvdsController.collectionView.reloadData()
                            dvdsController.checkIfUserHasDvds()
                        })
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension WelcomeScreen : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


// apple
