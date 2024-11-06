//
//  SignUpViewInput.swift
//  NotesApp
//
//  Created by Vladislav on 07.10.2022.
//

import Foundation

protocol SignUpViewInput: AnyObject {
    
    func setErrorEmail(_ isHidden: Bool)
    func setErrorPassword(_ isHidden: Bool)
    func enableButton(_ isEnabled: Bool)
    func pushNotesViewController()
    func showAlert(_ title: String, _ message: String)
    func showIndicator(_ isHidden: Bool)
}

