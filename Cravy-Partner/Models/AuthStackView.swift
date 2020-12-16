//
//  AuthStackView.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A vertical stack view that displays two textfields that handle email input and password input respectively and a RoundButton to trigger action for the inputs provided all.
class AuthStackView: UIStackView {
    private var emailTextField = RoundTextField(placeholder: "Email")
    private var passwordTextField = RoundTextField(placeholder: "Password")
    private var authButton = RoundButton()
    
    init() {
        super.init(frame: .zero)
        self.set(axis: .vertical, alignment: .center, distribution: .fillProportionally, spacing: 24)
        setTextFieldsStackView()
        setAuthButton()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTextFieldsStackView() {
        setTextField(textField: emailTextField, type: .emailAddress)
        setTextField(textField: passwordTextField, isSecure: true, returnType: .done)
        
        let vStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        vStackView.set(axis: .vertical, distribution: .fillEqually, spacing: 16)
        self.addArrangedSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        vStackView.widthAnchor(to: self)
    }
    
    private func setTextField(textField: UITextField, type: UIKeyboardType = .default, isSecure: Bool = false, returnType: UIReturnKeyType = .next) {
        textField.keyboardType = type
        textField.isSecureTextEntry = isSecure
        textField.returnKeyType = returnType
        textField.font = UIFont.regular.medium
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor(of: 60)
    }
    
    private func setAuthButton() {
        authButton.setTitle("LOGIN", for: .normal)
        authButton.titleLabel?.font = UIFont.bold.medium
        authButton.setTitleColor(K.Color.light, for: .normal)
        authButton.backgroundColor = K.Color.primary
        self.addArrangedSubview(authButton)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.widthAnchor(of: 160)
        authButton.heightAnchor(of: 45)
    }
}
