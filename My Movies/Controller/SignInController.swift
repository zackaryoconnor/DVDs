//
//  LogInController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 6/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.


import UIKit
import Firebase

class SignInController: SignInSignUpUIContoller {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(welcomeLabelText: "Sign in with \nemail", signInSignUpButtonText: "Sign In", signInSignUpButtonSelector:  #selector(handleSignInUser), needOrAlreadyHaveAccountButtonText: "Don't have an accout? Tap here.", needOrAlreadyHaveAccountButtonSelector: #selector(handleNeedAccountButtonPressed))
    }
    
    
    @objc func handleSignInUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                
                return
            } else if Auth.auth().currentUser?.uid == Auth.auth().currentUser?.uid {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
                    dvdsController.collectionView.reloadData()
                    dvdsController.checkIfUserHasDvds()
                })
            }
        }
        
    }
    
    
    @objc fileprivate func handleNeedAccountButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        
        weak var presentingController = self.presentingViewController
        dismiss(animated: true, completion: {
            presentingController?.present(SignUpController(), animated: true)
        })
        
    }
    
}




extension SignInController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            handleSignInUser()
        }
        return true
    }
}
