//
//  ResetPasswordViewInput.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 02.09.2025.
//

import Foundation
protocol ResetPasswordViewInput: AnyObject {
    func setErrorEmail(_ isHidden: Bool)
    func enableButtonSignIn(_ isEnabled: Bool)
    func clearEmailTextField()
}
