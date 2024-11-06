//
//  SignInViewController.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit

class SignInViewController: BaseViewController {
    
    private lazy var output: SignInViewOutput? = {
        let presenter = SignInPresenter()
        presenter.view = self
        return presenter
    }()
    
    private let spinner = UIActivityIndicatorView()
    private let emailTextField = UITextField()
    private let errorEmailLabel = UILabel()
    private let passwordTextField = UITextField()
    private let errorPasswordLabel = UITextView()
    private let signInButton = UIButton()
    private let emailLabel = UILabel()
    private let passwordLabel = UILabel()
    private let signUpButton = UIButton()
    private let laterButton = UIButton()
    private let signInLabel = UILabel()
    private lazy var stackViewContainer = UIStackView()
    private lazy var emailStackViewContainer = UIStackView()
    private lazy var passwordStackViewContainer = UIStackView()
    private lazy var buttonsStackViewContainer = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
    }
    
    func pushNotesViewController() {
        let notesVC = NotesViewController()
        self.navigationController?.pushViewController(notesVC, animated: true)
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
        buttonsStackViewContainer.addArrangedSubview(laterButton)
    }
    
    override func addConstraints() {
        signInLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                           bottom: stackViewContainer.topAnchor,
                           trailing: view.safeAreaLayoutGuide.trailingAnchor,
                           padding: .init(top: 20, left: 28, bottom: 40, right: 28))
        stackViewContainer.anchor(top: nil,
                                  leading: view.safeAreaLayoutGuide.leadingAnchor,
                                  bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: view.safeAreaLayoutGuide.trailingAnchor,
                                  padding: .init(top: 0, left: 28, bottom: 0, right: 28))
        spinner.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                       leading: view.safeAreaLayoutGuide.leadingAnchor,
                       bottom: view.safeAreaLayoutGuide.bottomAnchor,
                       trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
    override func setupUI() {
        signInLabel.font = .systemFont(ofSize: 25, weight: .medium)
        signInLabel.text = "Sign In".localized()
        
        stackViewContainer.axis = .vertical
        stackViewContainer.spacing = 20
        
        for stack in [emailStackViewContainer, passwordStackViewContainer, buttonsStackViewContainer] {
            stack.axis = .vertical
            stack.spacing = 10
        }
        
        for label in [emailLabel, passwordLabel] {
            label.font = .systemFont(ofSize: 17)
        }
        
        for label in [emailTextField, passwordTextField] {
            label.font = .systemFont(ofSize: 14)
        }
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        
        errorEmailLabel.font = .systemFont(ofSize: 14)
        errorEmailLabel.textColor = .red
        errorEmailLabel.isHidden = true
        
        errorPasswordLabel.font = .systemFont(ofSize: 14)
        errorPasswordLabel.textColor = .red
        errorPasswordLabel.isHidden = true

        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorPasswordLabel.text = "Password must contain 8 characters, 1 capital letter and 1 number".localized()
        
        emailLabel.text = "Email".localized()
        passwordLabel.text = "password".localized()
        signUpButton.setTitle("Don't have account? Sing Up".localized(), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonDidTap), for: .touchUpInside)
        signInButton.setTitle("Sign In".localized(), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonDidTap), for: .touchUpInside)
        laterButton.setTitle("Later".localized(), for: .normal)
        laterButton.addTarget(self, action: #selector(laterButtonDidTap), for: .touchUpInside)
    }
    
    @objc func signUpButtonDidTap(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func signInButtonDidTap(_ sender: UIButton) {
        output?.signInButtonDidTap()
    }
    
    @objc func laterButtonDidTap(_ sender: UIButton) {
        output?.laterButtonDidTap()
    }
    
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChange(_ sender: UITextField) {
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
