//
//  AuthStackView.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

//MARK:- AuthStackView

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

//MARK:- AccountStackView

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

//MARK:- TextStackView

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

//MARK:- GalleryView

/// A collection of RoundImageViews that are arranged in mutiple stackviews with a layout that is dynamic.
class GalleryView: UIStackView {
    private var imageViews: [RoundImageView] = []
    /// Returns a collection of RoundImageViews. The imageviews are assigned tags in relation to their position in which they were added in the view.
    var gallery: [RoundImageView] {
        return imageViews
    }
    /// Returns a collection of images displayed in the image views.
    var images: [UIImage] {
        set {
            if newValue.count > 0 {
                for i in 0...newValue.count - 1 {
                    gallery[i].tag = i
                    gallery[i].image = newValue[i]
                    gallery[i].contentMode = .scaleAspectFill
                    gallery[i].isUserInteractionEnabled = true
                }
            }
        }
        
        get {
            var images: [UIImage] = []
            gallery.forEach { (imageView) in
                if let image = imageView.image {
                    images.append(image)
                }
            }
            return images
        }
    }
    private var horizontalSpaceToFill: CGFloat {
        return UIScreen.main.bounds.width - (spacing+16)
    }
    private var verticalSpaceToFill: CGFloat {
        return height - spacing
    }
    /// The maximum number of round image views.
    static let MAX_SUBVIEWS: Int = 5
    private var height: CGFloat {
        return 320
    }
    
    init(frame: CGRect = .zero, layout: GALLERY_LAYOUT = .uzumaki, images: [UIImage] = []) {
        super.init(frame: frame)
        setImageViews()
        self.images = images
        setGalleryStackView(layout: layout)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageViews() {
        for _ in 0...GalleryView.MAX_SUBVIEWS - 1 {
            let imageView = RoundImageView(frame: .zero, roundfactor: 10)
            imageViews.append(imageView)
        }
    }
    
    func setGalleryStackView(layout: GALLERY_LAYOUT) {
        if layout == .uzumaki {
            setUzumakiLayout()
        } else {
            setUchihaLayout()
        }
    }
    
    private func setUzumakiLayout() {
        var vStackView1: UIStackView!
        var hStackView: UIStackView!
        
        if self.arrangedSubviews.isEmpty {
            self.set(axis: .horizontal, distribution: .fillProportionally, spacing: 3)
            
            //firstvertical
            vStackView1 = UIStackView(arrangedSubviews: [gallery[0]])
            vStackView1.set(axis: .vertical, distribution: .fillProportionally, spacing: spacing)
            
            hStackView = UIStackView(arrangedSubviews: [gallery[1], gallery[2]])
            hStackView.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            hStackView.heightAnchor(of: verticalSpaceToFill * 0.3)
            vStackView1.addArrangedSubview(hStackView)
            
            //secondVertical
            let vStackView2 = UIStackView(arrangedSubviews: [gallery[3], gallery[4]])
            vStackView2.set(axis: .vertical, distribution: .fill, spacing: spacing)
            
            
            //arrange all of them together in a horizontal stack view
            self.addArrangedSubview(vStackView1)
            self.addArrangedSubview(vStackView2)
        } else {
            vStackView1 = self.arrangedSubviews[0] as? UIStackView
            hStackView = vStackView1.arrangedSubviews[1] as? UIStackView
        }
        
        if images.count <= 3 {
            vStackView1.widthAnchor(of: horizontalSpaceToFill)
        } else {
            vStackView1.widthAnchor(of: horizontalSpaceToFill * 0.7)
        }
        
        if images.count == 4 {
            gallery[0].heightAnchor(of: verticalSpaceToFill * 0.7)
        } else {
            gallery[3].heightAnchor(of: verticalSpaceToFill * 0.3)
            gallery[4].heightAnchor(of: verticalSpaceToFill * 0.7)
        }
        gallery[4].isHidden = images.count == 4
        hStackView.isHidden = images.count == 1
    }
    
    private func setUchihaLayout() {
        var hStackView2: UIStackView!
        var hStackView1: UIStackView!
        
        if self.arrangedSubviews.isEmpty {
            self.set(axis: .vertical, distribution: .fill, spacing: 3)
            
            //first horizontal
            hStackView1 = UIStackView(arrangedSubviews: [gallery[0]])
            hStackView1.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            
            let vStackView = UIStackView(arrangedSubviews: [gallery[1], gallery[2]])
            vStackView.set(axis: .vertical, distribution: .fillProportionally, spacing: spacing)
            hStackView1.addArrangedSubview(vStackView)
            
            //second horizontal
            hStackView2 = UIStackView(arrangedSubviews: [gallery[3], gallery[4]])
            hStackView2.set(axis: .horizontal, distribution: .fillProportionally, spacing: spacing)
            hStackView2.heightAnchor(of: verticalSpaceToFill * 0.3)
            
            //arrange all of them together in a vertical stack view
            self.addArrangedSubview(hStackView1)
            self.addArrangedSubview(hStackView2)
        } else {
            hStackView1 = self.arrangedSubviews[0] as? UIStackView
            hStackView2 = self.arrangedSubviews[1] as? UIStackView
        }
        hStackView2.isHidden = images.count <= 3
        if images.count <= 3 {
            hStackView1.heightAnchor(of: verticalSpaceToFill)
        } else {
            hStackView1.heightAnchor(of: verticalSpaceToFill * 0.7)
        }
        if images.count == 4 {
            gallery[3].widthAnchor(of: horizontalSpaceToFill)
        } else if images.count == GalleryView.MAX_SUBVIEWS {
            gallery[3].widthAnchor(of: horizontalSpaceToFill * 0.7)
        }
    }
}
