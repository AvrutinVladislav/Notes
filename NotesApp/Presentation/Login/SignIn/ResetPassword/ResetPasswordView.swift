//
//  ResetPasswordView.swift
//  NotesApp
//
//  Created by Vladislav Avrutin on 01.09.2025.
//

import UIKit

protocol ResetPasswordViewDelegate: AnyObject {
    func resetPassword()
    func closeButton()
    func emailTextFieldDidChange(_ text: String)
}

final class ResetPasswordView: UIView {
    
    weak var delegate: ResetPasswordViewDelegate?
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let emailTextField = CustomTextField()
    private let errorEmailLabel = UILabel()
    private let resetPasswordButton = UIButton()
    private let closeButton = UIButton()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        backgroundColor = Colors.mainBackground
        
        for view in [titleLabel, emailTextField, errorEmailLabel,
                     resetPasswordButton, closeButton, stackView] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        titleLabel.text = "Forgot your password?"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        
        subTitleLabel.text = "Please enter the email address you`d like your password reset information send to"
        subTitleLabel.font = .systemFont(ofSize: 14)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textColor = .white
    
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.textColor = .black
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 1
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = .white
        emailTextField.placeholder = "Enter your email".localized()
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorEmailLabel.font = .systemFont(ofSize: 14)
        errorEmailLabel.textColor = .red
        errorEmailLabel.isHidden = true
        
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonDidTap), for: .touchUpInside)
        resetPasswordButton.setTitle("Reset password".localized(), for: .normal)
        resetPasswordButton.layer.borderColor = UIColor.black.cgColor
        resetPasswordButton.layer.borderWidth = 1
        resetPasswordButton.layer.cornerRadius = 10
        var config = UIButton.Configuration.filled()
        config.titlePadding = 5
        resetPasswordButton.configuration = config
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.isEnabled = false
        
        closeButton.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.backgroundColor = .white
        closeButton.layer.borderColor = UIColor.black.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.layer.cornerRadius = 10
        
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(errorEmailLabel)
        stackView.addArrangedSubview(resetPasswordButton)
        stackView.addArrangedSubview(closeButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -28),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    @objc private func resetPasswordButtonDidTap() {
        delegate?.resetPassword()
        print("~~~~~~~ Reset password button did tap ~~~~~~~~~")
    }
    
    @objc private func closeButtonDidTap() {
        delegate?.closeButton()
        print("~~~~~~~ Close button did tap ~~~~~~~~~")
    }
    
    @objc func textFieldDidChange() {
        delegate?.emailTextFieldDidChange(emailTextField.text ?? "")
    }
    
}

extension ResetPasswordView: ResetPasswordViewInput {
    func setErrorEmail(_ isHidden: Bool) {
        errorEmailLabel.isHidden = isHidden
    }
    
    func enableButtonSignIn(_ isEnabled: Bool) {
        resetPasswordButton.isEnabled = isEnabled
        resetPasswordButton.backgroundColor = isEnabled ? .white : .lightGray
        resetPasswordButton.tintColor = isEnabled ? .white : .black
    }
    
    func clearEmailTextField() {
        emailTextField.text = ""
    }
}
