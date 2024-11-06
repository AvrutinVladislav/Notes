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
    }
}

@objc extension BaseViewController {
    func addSubview() {}
    func addConstraints() {}
    func setupUI() {}
    
    func navBarRightButtonHandler() {
        print("Right button handler tapped")
    }
    
    func navBarLeftButtonHandler() {
        print("Left button handler tapped")
    }
}

extension BaseViewController {
    func addNavBarButton(at position: ButtonPosition, with title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        switch position {
        case .left:
            button.addTarget(self, action: #selector(navBarLeftButtonHandler), for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: #selector(navBarRightButtonHandler), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
}
