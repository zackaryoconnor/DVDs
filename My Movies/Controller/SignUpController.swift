//
//  SignUpController.swift
//  My Movies
//
//  Created by Zackary O'Connor on 6/7/19.
//  Copyright © 2019 Zackary O'Connor. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: SigninSignUpUIContoller {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI(welcomeLabelText: "Sign Up", signInSignUpButtonText: "Sign Up cuz", signInSignUpButtonSelector: #selector(handleSignUpUser), needOrAlreadyHaveAccountButtonText: "Already have an accout? Tap here.", needOrAlreadyHaveAccountButtonSelector: #selector(handleAlreadyHaveAccountButtonPressed))
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
            firebaseDatabaseReference.child(firebaseUsersReference).child(uid).updateChildValues(["email": email])
            
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }
    }
    
    
    @objc func handleAlreadyHaveAccountButtonPressed() {
        emailTextField.text = ""
        passwordTextField.text = ""
        dismiss(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.present(SignInController(), animated: true)
        }
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
