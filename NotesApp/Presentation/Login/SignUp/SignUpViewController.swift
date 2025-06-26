//
//  SignUpViewController.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    var output: SignUpViewOutput?
    
    private let spinner = UIActivityIndicatorView()
    private let errorEmailLabel = UILabel()
    private let emailTextField = CustomTextField()
    private let passwordTextField = CustomTextField()
    private let errorPasswordLabel = UILabel()
    private let signUpButton = UIButton()
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
    private let signUpLabel = UILabel()
    private let stackViewContainer = UIStackView()
    private let emailStackViewContainer = UIStackView()
    private let passwordStackViewContainer = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
        setupUI()
    }
    
}

extension SignUpViewController: SignUpViewInput {
    func setErrorEmail(_ isHidden: Bool) {
        errorEmailLabel.isHidden = isHidden
    }
    
    func setErrorPassword(_ isHidden: Bool) {
        errorPasswordLabel.isHidden = isHidden
    }
    
    func enableButton(_ isEnabled: Bool) {
        signUpButton.isEnabled = isEnabled
        signUpButton.backgroundColor = isEnabled ? .white : .lightGray
        signUpButton.tintColor = isEnabled ? .white : .black
    }
    
    func pushNotesViewController() {
        self.navigationController?.pushViewController(NotesBuilder.build(), animated: true)
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func showIndicator(_ isActive: Bool) {
        if isActive {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
}
    
extension SignUpViewController {
    
    override func setupUI() {
        for view in [spinner, errorEmailLabel, emailTextField, passwordTextField,
                     errorPasswordLabel, signUpButton, emailLabel, passwordLabel,
                     signUpLabel, stackViewContainer, emailStackViewContainer,
                     passwordStackViewContainer] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        spinner.color = .black
        spinner.style = .large
        
        stackViewContainer.axis = .vertical
        stackViewContainer.spacing = 20
        
        for stack in [emailStackViewContainer, passwordStackViewContainer] {
            stack.axis = .vertical
            stack.spacing = 10
        }
        
        for label in [emailLabel, passwordLabel] {
            label.font = .systemFont(ofSize: 17)
            label.textColor = .white
        }
        
        for label in [emailTextField, passwordTextField] {
            label.font = .systemFont(ofSize: 14)
            label.textColor = .white
        }
        
        for tf in [emailTextField, passwordTextField] {
            tf.font = .systemFont(ofSize: 14)
            tf.textColor = .black
            tf.layer.cornerRadius = 10
            tf.layer.borderColor = UIColor.black.cgColor
            tf.layer.borderWidth = 1
            tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        emailTextField.placeholder = "Enter your email".localized()
        
        passwordTextField.placeholder = "Enter your password".localized()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
                
        errorEmailLabel.font = .systemFont(ofSize: 14)
        errorEmailLabel.textColor = .red
        errorEmailLabel.isHidden = true
        
        errorPasswordLabel.font = .systemFont(ofSize: 14)
        errorPasswordLabel.textColor = .red
        errorPasswordLabel.isHidden = true
        errorPasswordLabel.numberOfLines = 3
        
        emailLabel.text = "Email".localized()
        passwordLabel.text = "password".localized()

        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorPasswordLabel.text = "Your password should be 8+ characters with a mix of uppercase letters, numbers, and special symbols like !@#$%^&* etc.".localized()
        
        emailLabel.text = "Email".localized()
        passwordLabel.text = "Password".localized()
        
        signUpButton.setTitle("Sign Up".localized(), for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        signUpButton.clipsToBounds = true
        
        setupNavigationBar(title: "Sign Up", rightButtonTitle: nil, leftButtonTitle: "Back")
        leftButtonAction = { [weak self] in
            self?.backButtonDidTap()
        }
    }
    
    override func addSubview() {
        view.addSubview(signUpLabel)
        view.addSubview(stackViewContainer)
        view.addSubview(spinner)
        stackViewContainer.addArrangedSubview(emailStackViewContainer)
        stackViewContainer.addArrangedSubview(passwordStackViewContainer)
        stackViewContainer.addArrangedSubview(signUpButton)
        emailStackViewContainer.addArrangedSubview(emailLabel)
        emailStackViewContainer.addArrangedSubview(emailTextField)
        emailStackViewContainer.addArrangedSubview(errorEmailLabel)
        passwordStackViewContainer.addArrangedSubview(passwordLabel)
        passwordStackViewContainer.addArrangedSubview(passwordTextField)
        passwordStackViewContainer.addArrangedSubview(errorPasswordLabel)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stackViewContainer.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: 40),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            stackViewContainer.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Handles
    @objc func signUpButtonDidTap(_ sender: UIButton) {
        output?.signUpButtonDidTap()
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        switch sender {
        case emailTextField:
            output?.emailTextFieldDidChange(emailTextField.text ?? "")
        case passwordTextField:
            output?.passwordTextFieldDidChange(passwordTextField.text ?? "")
        default:
            break
        }
    }
    
    @objc func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

