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
    
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubview()
        addConstraints()
    }
    
    func setupNavigationBar(title: String?, rightButtonTitle: String?, leftButtonTitle: String?) {
        navigationController?.navigationBar.backgroundColor = .clear
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.text = title
        navigationItem.titleView = titleLabel
        
        let leftButton = UIBarButtonItem(
            title: leftButtonTitle,
            style: .plain,
            target: self,
            action: #selector(leftButtonTapped)
        )
        leftButton.tintColor = .black
        
        let rightButton = UIBarButtonItem(
            title: rightButtonTitle,
            style: .plain,
            target: self,
            action: #selector(rightButtonTapped)
        )
        rightButton.tintColor = .black

        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
    }
}

@objc extension BaseViewController {
    func addSubview() {}
    func addConstraints() {}
    func setupUI() {}
    
    
    
    @objc private func leftButtonTapped() {
        leftButtonAction?()
    }
    
    @objc private func rightButtonTapped() {
        rightButtonAction?()
    }
}

