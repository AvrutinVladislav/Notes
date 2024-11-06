//
//  SignUpViewOutput.swift
//  NotesApp
//
//  Created by Vladislav on 07.10.2022.
//

import Foundation

protocol SignUpViewOutput: AnyObject{
   
    func viewDidLoad()
    func emailTextFieldDidChange(_ text: String)
    func passwordTextFieldDidChange(_ text: String)
    func signUpButtonDidTap()
    
}
