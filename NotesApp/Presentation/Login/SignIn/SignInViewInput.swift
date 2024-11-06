//
//  SignInViewInput.swift
//  NotesApp
//
//  Created by Vladislav on 06.10.2022.
//

import Foundation

protocol SignInViewInput: AnyObject {
    
    func setErrorEmail(_ isHidden: Bool)
    func setErrorPassword(_ isHidden: Bool)
    func enableButtonSignIn(_ isEnabled: Bool)
    func pushNotesViewController()
    func showAlert(_ title: String, _ message: String)
    func showIndicator(_ isActive: Bool)

}
