//
//  String.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import Foundation

extension String{
    
    var isPassword: Bool {
        //проверка написания password
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    //проверка написания username
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func localized(comment: String = "") -> String {
        
        return NSLocalizedString(self, comment: comment)
    }
    
}
