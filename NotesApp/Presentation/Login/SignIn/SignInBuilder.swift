//
//  SignInBuilder.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 09.11.2024.
//

import Foundation

final class SignInBuilder {
    class func build() -> SignInViewController {
        let view = SignInViewController()
        let fbManager = FirebaseManagerImpl()
        let presenter = SignInPresenter(fbManager: fbManager,
                                        view: view)
        view.output = presenter
        return view
    }
}
