//
//  SceneDelegate.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let vc = SignInBuilder.build()
        let navigationVC = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationVC
        self.window = window
        self.window?.makeKeyAndVisible()
    }

}
