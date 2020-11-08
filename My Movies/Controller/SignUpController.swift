//
//  SignUpController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 6/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: SignInSignUpUIContoller {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(welcomeLabelText: "Sign up with \nemail", signInSignUpButtonText: "Sign Up", signInSignUpButtonSelector: #selector(handleSignUpUser), needOrAlreadyHaveAccountButtonText: "Already have an accout? Tap here.", needOrAlreadyHaveAccountButtonSelector: #selector(handleAlreadyHaveAccountButtonPressed))
        
        forgotPasswordButton.isEnabled = false
        forgotPasswordButton.layer.opacity = 0
    }
    
    
    @objc func handleSignUpUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, error) in
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error?._code ?? 0) {
                    self.displayAlertController(title: "Error", message: errorCode.errorMessage, buttonTitle: "ok")
                }
                
                return
            }

            guard let uid = Auth.auth().currentUser?.uid else { return }
            firebase.databaseReference.child(firebase.usersReference).child(uid).updateChildValues(["email": email])
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
    }
    
    
    @objc func handleAlreadyHaveAccountButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        
        weak var presentingController = self.presentingViewController
        dismiss(animated: true, completion: {
            presentingController?.present(SignInController(), animated: true)
        })
        
    }
    
}




extension SignUpController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            handleSignUpUser()
        }
        return true
    }
}
