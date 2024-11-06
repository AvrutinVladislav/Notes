//
//  SignUpViewController.swift
//  NotesApp
//
//  Created by Vladislav on 04.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private lazy var output: SignUpViewOutput? = {
        
        let presenter = SignUpPresenter()
        presenter.view = self
        return presenter
    }()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output?.viewDidLoad()
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
    }
    
    func pushNotesViewController() {
        
        self.navigationController?.pushViewController(NotesViewController(), animated: true)
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
    
private extension SignUpViewController {
    
    func setupUI() {
        
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
        errorEmailLabel.text = "Enter a valid email, example: mike@gmail.com".localized()
        errorPasswordLabel.text = "Password must contain 8 characters, 1 capital letter and 1 number".localized()
        signUpLabel.text = "Sign Up".localized()
        emailLabel.text = "Email".localized()
        passwordLabel.text = "password".localized()
        signUpButton.setTitle("Sign Up".localized(), for: .normal)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localized(), style: .done, target: nil, action: nil)
    }
    
    //MARK: - Handles
    @IBAction func signUpButtonDidTap(_ sender: UIButton) {
        
        output?.signUpButtonDidTap()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        switch sender {
        case emailTextField:
            output?.emailTextFieldDidChange(emailTextField?.text ?? "")
        case passwordTextField:
            output?.passwordTextFieldDidChange(passwordTextField?.text ?? "")
        default:
            break
        }
    }
    
}
