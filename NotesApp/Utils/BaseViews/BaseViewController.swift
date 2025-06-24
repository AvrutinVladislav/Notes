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
        view.backgroundColor = Colors.mainBackground
        setupUI()
        addSubview()
        addConstraints()
    }
    
    func setupNavigationBar(title: String?,
                            rightButtonTitle: String? = nil,
                            rightImage: UIImage? = nil,
                            leftButtonTitle: String? = nil,                            
                            leftImage: UIImage? = nil) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        titleLabel.text = title
        navigationItem.titleView = titleLabel
        
        if let leftImage {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: leftImage,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(leftButtonTapped))
            
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: leftButtonTitle,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(leftButtonTapped))
        }
        
        if let rightImage {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightImage,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(rightButtonTapped))
            
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightButtonTitle,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(rightButtonTapped))
        }
        

        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
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

