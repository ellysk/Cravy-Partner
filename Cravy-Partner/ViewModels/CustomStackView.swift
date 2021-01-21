//
//  AuthStackView.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A vertical stack view that displays two textfields that handle email input and password input respectively and a RoundButton to trigger action for the inputs provided all.
class AuthStackView: UIStackView, UITextFieldDelegate {
    private var emailTextField = RoundTextField(placeholder: K.UIConstant.email)
    private var passwordTextField = RoundTextField(placeholder: K.UIConstant.password)
    private var authButton = RoundButton()
    var beginResponder: Bool {
        set {
            if newValue {
                emailTextField.becomeFirstResponder()
            }
        }
        
        get {
            return emailTextField.isFirstResponder || passwordTextField.isFirstResponder
        }
    }
    /// A boolean value that determines if the user has filled some inputs on both textfields.
    var isFullFields: Bool {
        if let email = emailTextField.text, let password = passwordTextField.text {
            return email != "" && password != ""
        } else {
            return false
        }
    }
    var authenticate: ()->() = {}
    
    init() {
        super.init(frame: .zero)
        self.set(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 24)
        setTextFieldsStackView()
        setAuthButton()
        updateAuthButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.set(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 24)
        setTextFieldsStackView()
        setAuthButton()
        updateAuthButton()
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
    
    private func setTextField(textField: RoundTextField, type: UIKeyboardType = .default, isSecure: Bool = false, returnType: UIReturnKeyType = .next) {
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.delegate = self
        textField.keyboardType = type
        textField.isSecureTextEntry = isSecure
        textField.returnKeyType = returnType
        textField.font = UIFont.regular.medium
        textField.textAlignment = .center
        textField.isBordered = true
        textField.backgroundColor = K.Color.light.withAlphaComponent(0.8)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor(of: 60)
    }
    
    private func setAuthButton() {
        authButton.addTarget(self, action: #selector(auth(_:)), for: .touchUpInside)
        authButton.setTitle(K.UIConstant.login, for: .normal)
        authButton.titleLabel?.font = UIFont.bold.medium
        authButton.setTitleColor(K.Color.light, for: .normal)
        authButton.backgroundColor = K.Color.primary
        self.addArrangedSubview(authButton)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        authButton.sizeAnchorOf(width: 160, height: 45)
    }
    
    private func updateAuthButton() {
        authButton.isEnabled = isFullFields
        authButton.backgroundColor = isFullFields ? K.Color.primary : K.Color.dark
        authButton.alpha = isFullFields ? 1 : 0.5
    }
    
    /// Checks to see which repsonder is first and resigns it. Makes sure there is no active responder.
    func resignFirstResponders() {
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        } else if passwordTextField.isFirstResponder {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateAuthButton()
    }
    
    @objc private func auth(_ sender: RoundButton) {
        resignFirstResponders()
        authenticate()
    }
    
    //MARK:- UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            return string != " "
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

/// A vertical stack view that displays interactive views in which the user can edit account details such as logo, name, email and phone number.
class AccountStackView: UIStackView {
    var logoImageView: RoundImageView!
    var nameTextField: RoundTextField!
    var emailTextField: RoundTextField!
    var numberTextField: RoundTextField!
    private var textField: RoundTextField {
        let field = RoundTextField(roundFactor: 5)
        field.returnKeyType = .done
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor(of: 45)
        return field
    }
    
    init() {
        super.init(frame: .zero)
        self.set(axis: .vertical, distribution: .equalSpacing)
        setAccountStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setAccountStackView()
    }
    
    private func setAccountStackView() {
        logoImageView = RoundImageView(image: nil, roundfactor: 5)
        logoImageView.showsPlaceholder = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.sizeAnchorOf(width: 100, height: 100)
        
        nameTextField = textField
        nameTextField.keyboardType = .default
        emailTextField = textField
        emailTextField.keyboardType = .emailAddress
        numberTextField = textField
        numberTextField.keyboardType = .phonePad
        
        self.addArrangedSubview(logoImageView.withSectionTitle(K.UIConstant.addBusinessLogo, alignment: .leading))
        self.addArrangedSubview(nameTextField.withSectionTitle(K.UIConstant.changeBusinessName))
        self.addArrangedSubview(emailTextField.withSectionTitle(K.UIConstant.changeBusinessEmail))
        self.addArrangedSubview(numberTextField.withSectionTitle(K.UIConstant.changePhoneNumber))
    }
}

protocol CravyTextDelegate {
    func textDidChange(on textField: UITextField, newText: String)
    func textDidChange(on textView: UITextView, newText: String)
}

/// A vertical stack view that displays a textfield and a textview.
class TextStackView: UIStackView, UITextFieldDelegate, UITextViewDelegate {
    private var textField: RoundTextField!
    private var textView: RoundTextView!
    var beginResponder: Bool {
        set {
            if newValue {
                textField.becomeFirstResponder()
            } else {
                if textField.isFirstResponder {
                    textField.resignFirstResponder()
                } else if textView.isFirstResponder {
                    textView.resignFirstResponder()
                }
            }
        }
        
        get {
            return textField.isFirstResponder || textView.isFirstResponder
        }
    }
    var isValid: Bool {
        if let textFieldText = textField.text, !textView.textIsPlaceholder {
            return textFieldText.removeLeadingAndTrailingSpaces != "" && textView.text.removeLeadingAndTrailingSpaces != ""
        } else {
            return false
        }
    }
    var delegate: CravyTextDelegate?
    
    init() {
        super.init(frame: .zero)
        self.set(axis: .vertical, alignment: .fill, distribution: .fillProportionally, spacing: 24)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setTextStackView()
    }
    
    private func setTextStackView() {
        setTextField()
        setTextView()
        self.addArrangedSubview(textField.withSectionTitle(K.UIConstant.title, titleFont: UIFont.bold.medium, titleColor: K.Color.light))
        self.addArrangedSubview(textView.withSectionTitle(K.UIConstant.description, titleFont: UIFont.bold.medium, titleColor: K.Color.light))
    }
    
    private func setTextField() {
        textField = RoundTextField(roundFactor: 5, placeholder: K.UIConstant.titlePlaceholder)
        textField.isBordered = true
        textField.backgroundColor = K.Color.light.withAlphaComponent(0.8)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor(of: 45)
    }
    
    private func setTextView() {
        textView = RoundTextView(roundFactor: 15, placeholder: K.UIConstant.descriptionPlaceholder)
        textView.delegate = self
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor(of: 200)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        self.delegate?.textDidChange(on: textField, newText: text.removeLeadingAndTrailingSpaces)
    }
    
    //MARK:- UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            textView.isFirstResponder = true
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK:- UITextView Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView.isFirstResponder = true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.textDidChange(on: textView, newText: textView.text.removeLeadingAndTrailingSpaces)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textView.isFirstResponder = false
    }
}
