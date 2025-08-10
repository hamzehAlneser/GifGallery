//
//  LoginViewController.swift
//  GIFGallert
//
//  Created by Hamzeh on 07/08/2025.
//

import UIKit

final class LoginViewController: BaseViewController {
    private let viewModel: LoginViewModel
    
    // MARK: - UI Properties
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel(style: .title)
    private let discoveryLabel = UILabel(style: .body)
    
    private let emailTextField = UITextField(roundedCorners: 20)
    private let emptyEmailErrorLabel = UILabel(style: .body)
    
    private let passwordTextField = UITextField(roundedCorners: 20)
    private let emptyPasswordErrorLabel = UILabel(style: .body)
    
    private let loginButton = UIButton(style: .common)
    
    //MARK: - Life Cycle
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
    }
    
}

//MARK: - Binding & Logic
extension LoginViewController {
    private func bindViewModel() {
        viewModel.onLoginFailure = { [weak self] errorText in
            guard let self else { return }
            
            DispatchQueue.main.async {[weak self ] in
                guard let self else { return }
                showAlert(title: "Invalid Login", text: errorText)
            }

        }
    }
    
    private func performLogin() {
        guard validInputs(),
              let emailText = emailTextField.text,
              let passwordText = passwordTextField.text
        else { return }
        
        showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self ] in
            guard let self else { return }
            viewModel.login(email: emailText, password: passwordText)
        }
    }
    
    private func validInputs() -> Bool {
        let emailEmpty = emailTextField.text?.isEmpty ?? true
        let passwordEmpty = passwordTextField.text?.isEmpty ?? true

        emptyEmailErrorLabel.isHidden = !emailEmpty
        emptyPasswordErrorLabel.isHidden = !passwordEmpty

       return !emailEmpty && !passwordEmpty
    }
}

//MARK: - UI
extension LoginViewController {
    private func setupUI() {
        setupHierarchy()
        setuplogoImageViewUI()
        setupTitleLabelUI()
        setupDiscoverLabelUI()
        setupEmailTextfieldUI()
        setupPasswordTextfieldUI()
        setupLoginButtonUI()
    }
    
    private func setupHierarchy() {
        view.addSubviews(
            logoImageView.useCodeLayout(),
            titleLabel.useCodeLayout(),
            discoveryLabel.useCodeLayout(),
            emailTextField.useCodeLayout(),
            emptyEmailErrorLabel.useCodeLayout(),
            passwordTextField.useCodeLayout(),
            emptyPasswordErrorLabel.useCodeLayout(),
            loginButton.useCodeLayout()
        )
    }
    
    private func setuplogoImageViewUI() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupTitleLabelUI() {
        titleLabel.text = "GIFGallery"
        titleLabel.textAlignment = .center
    }
    
    private func setupDiscoverLabelUI() {
        discoveryLabel.text = "Explore a world of animated images."
        discoveryLabel.textAlignment = .center
    }
    
    private func setupEmailTextfieldUI() {
        emailTextField.placeholder = "Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.text = "User@shahid.net"
        
        emptyEmailErrorLabel.text = "Email is required."
        emptyEmailErrorLabel.textColor = .red
        emptyEmailErrorLabel.font = .systemFont(ofSize: 13)
        emptyEmailErrorLabel.isHidden = true
    }
    
    private func setupPasswordTextfieldUI() {
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.text = "1234"
        
        emptyPasswordErrorLabel.text = "Password is required."
        emptyPasswordErrorLabel.textColor = .red
        emptyPasswordErrorLabel.font = .systemFont(ofSize: 13)
        emptyPasswordErrorLabel.isHidden = true
    }
    
    private func setupLoginButtonUI() {
        loginButton.setTitle( "Login", for: .normal)
        loginButton.addTarget(self, action: #selector(LoginTapped), for: .touchUpInside)
    }
    @objc func LoginTapped() {
        performLogin()
    }
}

//MARK: - Layout
extension LoginViewController {
    private func setupLayout() {
        setuplogoImageViewLayout()
        setupTitleLabelLayout()
        setupDiscoveryLabelLayout()
        setupEmailTextFieldLayout()
        setupPasswordTextFieldLayout()
        setupLoginButtonLayout()
    }
    
    private func setuplogoImageViewLayout() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupDiscoveryLabelLayout() {
        NSLayoutConstraint.activate([
            discoveryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            discoveryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            discoveryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            discoveryLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupEmailTextFieldLayout() {
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: discoveryLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emptyEmailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5),
            emptyEmailErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 10),
            emptyEmailErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            emptyEmailErrorLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupPasswordTextFieldLayout() {
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emptyPasswordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5),
            emptyPasswordErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 10),
            emptyPasswordErrorLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            emptyPasswordErrorLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLoginButtonLayout() {
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
