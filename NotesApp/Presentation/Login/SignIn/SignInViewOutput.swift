//
//  SignInViewOutput.swift
//  NotesApp
//
//  Created by Vladislav on 06.10.2022.
//

import UIKit

protocol SignInViewOutput: AnyObject {    
    func viewDidLoad()
    func emailTextFieldDidChange(_ text: String)
    func passwordTextFieldDidChange(_ text: String)
    func laterButtonDidTap()
    func signInButtonDidTap()
    func resetPassword()
    func resetPasswordEmailDidChange(_ text: String)
    func closeResetView()
    func googleAuthButtonDidTap(_ vc: UIViewController)
}
