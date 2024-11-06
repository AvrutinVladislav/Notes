//
//  SignInPresenter.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import Foundation

class SignInPresenter {
    
    weak var view: SignInViewInput?
    
    private var email = ""
    private var password = ""
    
}

extension SignInPresenter: SignInViewOutput {
    
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
    
    func laterButtonDidTap() {
        
        view?.pushNotesViewController()
    }
    
    func signInButtonDidTap() {
        
        guard validate() else { return }
        view?.showIndicator(true)
        FirebaseManager().autorization(email: email, password: password) { [weak self] result in
            
            guard let self = self else { return }
            self.view?.showIndicator(false)
            switch result {
            case .success(_):
                self.view?.pushNotesViewController()
            case .failure(let error):
                self.view?.showAlert("Error", "\(error.localizedDescription)")
            }
        }
    }
    
}

private extension SignInPresenter {
    
    func setupInitialState() {
        
        checkAuthUser()
        validate()
    }
    
    func checkAuthUser() {
        
        if FirebaseManager.isSignIn() {
            
            view?.pushNotesViewController()
        }
    }
    
    @discardableResult
    func validate() -> Bool {
        
        let validate = email.isEmail && password.isPassword
        view?.setErrorEmail(email.isEmail || email.isEmpty)
        view?.setErrorPassword(password.isPassword || password.isEmpty)
        view?.enableButtonSignIn(validate)
        return validate
    }
    
}
