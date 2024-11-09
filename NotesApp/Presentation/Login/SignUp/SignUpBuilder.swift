//
//  SignUpBuilder.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 09.11.2024.
//

import Foundation

final class SignUpBuilder {
    class func build() -> SignUpViewController {
        let view = SignUpViewController()
        let fbManager = FirebaseManagerImpl()
        let presenter = SignUpPresenter(view: view,
                                        fbManager: fbManager)
        view.output = presenter
        return view
    }
}
