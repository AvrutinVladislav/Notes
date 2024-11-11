//
//  BaseViewController.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 06.11.2024.
//

import UIKit

enum ButtonPosition {
    case left
    case right
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        addConstraints()
        setupUI()
        view.backgroundColor = .white
    }
}

@objc extension BaseViewController {
    func addSubview() {}
    func addConstraints() {}
    func setupUI() {}
    
}

