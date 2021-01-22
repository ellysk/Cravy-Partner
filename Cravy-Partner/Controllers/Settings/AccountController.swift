//
//  AccountController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of account details.
class AccountController: UIViewController {
    @IBOutlet weak var accountStackView: AccountStackView!
    @IBOutlet weak var logOutButton: UIButton!
    var saveButton: UIBarButtonItem? {
        return self.navigationItem.rightBarButtonItem
    }
    var image: UIImage? {
        set {
            accountStackView.logoImageView.image = newValue
            accountStackView.logoImageView.showsPlaceholder = !isImageEdited
            reloadEditable()
        }
        
        get {
            return accountStackView.logoImageView.image
        }
    }
    var name: String {
        set {
            accountStackView.nameTextField.text = newValue
            reloadEditable()
        }
        
        get {
            return accountStackView.nameTextField.text!
        }
    }
    var email: String {
        set {
            accountStackView.emailTextField.text = newValue
            accountStackView.emailSectionTitle = nil
            reloadEditable()
        }
        
        get {
            return accountStackView.emailTextField.text!
        }
    }
    var phoneNumber: String {
        set {
            accountStackView.numberTextField.text = newValue
            reloadEditable()
        }
        
        get {
            return accountStackView.numberTextField.text!
        }
    }
    var defaultValues: [String:Any] = [:] //TODO
    var isImageEdited: Bool {
        return image != nil && image != defaultValues[K.Key.image] as? UIImage
    }
    var isNameEdited: Bool {
        guard let businessName = defaultValues[K.Key.name] as? String else {return false}
        return name != businessName
    }
    var isEmailEdited: Bool {
        guard let businessEmail = defaultValues[K.Key.email] as? String else {return false}
        return email != businessEmail
    }
    var isPhoneNumberEdited: Bool {
        guard let businessNumber = defaultValues[K.Key.number] as? String else {return false}
        return phoneNumber != businessNumber
    }
    var isBusinessEdited: Bool {
        return isImageEdited || isNameEdited || isEmailEdited || isPhoneNumberEdited
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaultValues()
        // Do any additional setup after loading the view.
        self.title = K.UIConstant.account
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges(_:)))
        saveButton?.isEnabled = false
        accountStackView.logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhotoAction(_:))))
        accountStackView.nameTextField.delegate = self
        accountStackView.emailTextField.delegate = self
        accountStackView.numberTextField.delegate = self
    }
    
    /// Assign the variables to the default values.
    private func setUpDefaultValues() {
        //TODO
        defaultValues.updateValue(UIImage(named: "bgimage")!, forKey: K.Key.image)
        defaultValues.updateValue("EAT Restaurant & Cafe", forKey: K.Key.name)
        defaultValues.updateValue("eat@restcafe.co.uk", forKey: K.Key.email)
        defaultValues.updateValue("07948226722", forKey: K.Key.number)
        
        image = defaultValues[K.Key.image] as? UIImage
        name = defaultValues[K.Key.name] as! String
        email = defaultValues[K.Key.email] as! String
        phoneNumber = defaultValues[K.Key.number] as! String
    }
    
    private func reloadEditable() {
        saveButton?.isEnabled = isBusinessEdited
    }
    
    @objc func editPhotoAction(_ gesture: UITapGestureRecognizer) {
        self.presentEditPhotoAlert(in: self, message: K.UIConstant.addBusinessLogoMessage)
    }
    
    @objc func saveChanges(_ sender: UIBarButtonItem) {
        //TODO
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        //TODO
    }
}

extension AccountController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.removeLeadingAndTrailingSpaces != "" {
            if textField == accountStackView.nameTextField {
                name = text
            } else if textField == accountStackView.emailTextField {
                if K.Predicate.emailPredicate.evaluate(with: text) {
                    email = text
                } else {
                    accountStackView.emailSectionTitle = K.UIConstant.emailFormatAlert
                }
            } else if textField == accountStackView.numberTextField {
                phoneNumber = text
            }
        } else {
            if textField == accountStackView.nameTextField {
                name = defaultValues[K.Key.name] as! String
            } else if textField == accountStackView.emailTextField {
                email = defaultValues[K.Key.email] as! String
            } else if textField == accountStackView.numberTextField {
                phoneNumber = defaultValues[K.Key.number] as! String
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- ImageViewController Delegate
extension AccountController: ImageViewControllerDelegate {
    func didConfirmImage(_ image: UIImage) {
        self.image = image
    }
}
