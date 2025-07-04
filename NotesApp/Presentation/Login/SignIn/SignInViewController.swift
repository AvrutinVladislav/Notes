//
//  SignInViewController.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit

class SignInViewController: BaseViewController {
    
    var output: SignInViewOutput?
    
    private let spinner = UIActivityIndicatorView(style: .large)
    private let emailTextField = CustomTextField()
    private let errorEmailLabel = UILabel()
    private let passwordTextField = CustomTextField()
    private let errorPasswordLabel = UILabel()
    private let signInButton = UIButton()
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
    private let signUpButton = UIButton()
    private let laterButton = UIButton()
    private let signInLabel = UILabel()
    private let stackViewContainer = UIStackView()
    private let emailStackViewContainer = UIStackView()
    private let passwordStackViewContainer = UIStackView()
    private let buttonsStackViewContainer = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.viewDidLoad()
    }
}

extension SignInViewController: SignInViewInput {
    func setErrorEmail(_ isHidden: Bool) {
        errorEmailLabel.isHidden = isHidden
    }
    
    func setErrorPassword(_ isHidden: Bool) {
        errorPasswordLabel.isHidden = isHidden
    }
    
    func enableButtonSignIn(_ isEnabled: Bool) {
        signInButton.isEnabled = isEnabled
        signInButton.backgroundColor = isEnabled ? .white : .lightGray
        signInButton.tintColor = isEnabled ? .white : .black
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

extension SignInViewController {
    override func setupUI() {
        for view in [spinner, errorEmailLabel, emailTextField, passwordTextField,
                     errorPasswordLabel, signUpButton, emailLabel, passwordLabel,
                     signInLabel, stackViewContainer, emailStackViewContainer,
                     passwordStackViewContainer, buttonsStackViewContainer] {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        spinner.color = .black
        spinner.style = .large
        
        setupNavigationBar(title: "Sign In")
        
        stackViewContainer.axis = .vertical
        stackViewContainer.spacing = 20
        
        for stack in [emailStackViewContainer, passwordStackViewContainer, buttonsStackViewContainer] {
            stack.axis = .vertical
            stack.spacing = 10
        }
        
        for label in [emailLabel, passwordLabel] {
            label.font = .systemFont(ofSize: 17)
            label.textColor = .white
        }
        
        for tf in [emailTextField, passwordTextField] {
            tf.font = .systemFont(ofSize: 14)
            tf.textColor = .white
            tf.layer.cornerRadius = 10
            tf.layer.borderColor = UIColor.black.cgColor
            tf.layer.borderWidth = 1
            tf.translatesAutoresizingMaskIntoConstraints = false
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

        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorPasswordLabel.text = "Your password should be 8+ characters with a mix of uppercase letters, numbers, and special symbols like !@#$%^&* etc.".localized()
        
        emailLabel.text = "Email".localized()
        passwordLabel.text = "Password".localized()
        
        for button in [signUpButton, signInButton, laterButton] {
            button.titleLabel?.font = .systemFont(ofSize: 14)
        }
        
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.contentHorizontalAlignment = .leading
        let text = NSMutableAttributedString(string: "Don't have account? ")
        let signUp = NSAttributedString(string: "Sign Up",
                                        attributes: [.foregroundColor: UIColor.white,
                                                     .font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        text.append(signUp)
        signUpButton.setAttributedTitle(text, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        
        signInButton.setTitle("Sign In".localized(), for: .normal)
        signInButton.layer.borderColor = UIColor.black.cgColor
        signInButton.layer.borderWidth = 1
        signInButton.layer.cornerRadius = 10
        var config = UIButton.Configuration.filled()
        config.titlePadding = 5
        signInButton.configuration = config
        signInButton.clipsToBounds = true
        signInButton.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
        
//        laterButton.setTitle("Later".localized(), for: .normal)
//        laterButton.setTitleColor(.white, for: .normal)
//        laterButton.addTarget(self, action: #selector(laterButtonDidTap), for: .touchUpInside)
    }
    
    override func addSubview() {
        view.addSubview(signInLabel)
        view.addSubview(stackViewContainer)
        view.addSubview(spinner)
        stackViewContainer.addArrangedSubview(emailStackViewContainer)
        stackViewContainer.addArrangedSubview(passwordStackViewContainer)
        stackViewContainer.addArrangedSubview(signUpButton)
        stackViewContainer.addArrangedSubview(buttonsStackViewContainer)
        emailStackViewContainer.addArrangedSubview(emailLabel)
        emailStackViewContainer.addArrangedSubview(emailTextField)
        emailStackViewContainer.addArrangedSubview(errorEmailLabel)
        passwordStackViewContainer.addArrangedSubview(passwordLabel)
        passwordStackViewContainer.addArrangedSubview(passwordTextField)
        passwordStackViewContainer.addArrangedSubview(errorPasswordLabel)
        buttonsStackViewContainer.addArrangedSubview(signInButton)
//        buttonsStackViewContainer.addArrangedSubview(laterButton)
    }
    
    override func addConstraints() {
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInLabel.heightAnchor.constraint(equalToConstant: 30),
            
            stackViewContainer.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 40),
            stackViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stackViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func signUpButtonDidTap(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpBuilder.build(), animated: true)
    }
    
    @objc func signInButtonDidTap(_ sender: UIButton) {
        output?.signInButtonDidTap()
    }
    
    @objc func laterButtonDidTap(_ sender: UIButton) {
        output?.laterButtonDidTap()
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
    
}
