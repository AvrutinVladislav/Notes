//
//  SignInViewController.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    private lazy var output: SignInViewOutput? = {
        
        let presenter = SignInPresenter()
        presenter.view = self
        return presenter
    }()
   
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var signInLabel: UILabel!

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

private extension SignInViewController {
    
    func setupUI() {
        
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorPasswordLabel.text = "Password must contain 8 characters, 1 capital letter and 1 number".localized()
        signInLabel.text = "Sign In".localized()
        emailLabel.text = "Email".localized()
        passwordLabel.text = "password".localized()
        signUpButton.setTitle("Don't have account? Sing Up".localized(), for: .normal)
        laterButton.setTitle("Later".localized(), for: .normal)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        switch sender {
        case emailTextField:
            output?.emailTextFieldDidChange(emailTextField.text ?? "")
        case passwordTextField:
            output?.passwordTextFieldDidChange(passwordTextField.text ?? "")
        default:
            break
        }
    }
    
    @IBAction func signInButtonDidTap(_ sender: UIButton) {
        
        output?.signInButtonDidTap()
    }
    
    @IBAction func laterButtonDidTap(_ sender: UIButton) {
        
        output?.laterButtonDidTap()
    }
    
}
