//
//  CustomTextField.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 06.11.2024.
//

import UIKit

class CustomTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
