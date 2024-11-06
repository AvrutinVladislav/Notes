//
//  SignUpPresenter.swift
//  NotesApp
//
//  Created by Vladislav on 07.10.2022.
//

import Foundation

class SignUpPresenter {
    
    weak var view: SignUpViewInput?
    
    private var email = ""
    private var password = ""
    
}

extension SignUpPresenter: SignUpViewOutput {
    
    func viewDidLoad() {
        
        setupInitialState()
    }
    
    func emailTextFieldDidChange(_ text: String) {
        
        email = text
        validate()
    }
    
    func passwordTextFieldDidChange(_ text: String) {
        
        password = text
        validate()
    }
    
    func signUpButtonDidTap() {
        
        guard validate() else { return }
        view?.showIndicator(true)
        FirebaseManager().registration(email: email, password: password) { [weak self] result in
            
            guard let self = self else { return }
            self.view?.showIndicator(false)
            switch result {
                
            case .success(_):
                self.view?.pushNotesViewController()
            case .failure(_):
                self.view?.showAlert("Error", "Error of registration user")
            }
        }
    }
    
}

private extension SignUpPresenter {
    
    func setupInitialState() {
        
        validate()
    }
    
    @discardableResult
    func validate() -> Bool {
        
        let validate = email.isEmail && password.isPassword
        view?.setErrorEmail(email.isEmail || email.isEmpty)
        view?.setErrorPassword(password.isPassword || password.isEmpty)
        view?.enableButton(validate)
        return validate
    }
    
}
