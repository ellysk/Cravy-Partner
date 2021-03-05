//
//  AccountController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit
import CoreData

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
            if isImageEdited {
                updateData.updateValue(newValue, forKey: K.Key.logo)
            } else {
                updateData.removeValue(forKey: K.Key.logo)
            }
            reloadEditable()
        }
        
        get {
            return accountStackView.logoImageView.image
        }
    }
    var name: String {
        set {
            editedBusiness.name = newValue
            if isNameEdited {
                updateData.updateValue(newValue, forKey: K.Key.name)
            } else {
                updateData.removeValue(forKey: K.Key.name)
            }
            accountStackView.nameTextField.text = newValue
            reloadEditable()
        }
        
        get {
            return accountStackView.nameTextField.text!
        }
    }
    var email: String {
        set {
            editedBusiness.email = newValue
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
            editedBusiness.phoneNumber = newValue
            if isPhoneNumberEdited {
                updateData.updateValue(newValue, forKey: K.Key.number)
            } else {
                updateData.removeValue(forKey: K.Key.number)
            }
            accountStackView.numberTextField.text = newValue
            reloadEditable()
        }
        
        get {
            return accountStackView.numberTextField.text!
        }
    }
    var defaultBusiness: Business!
    var editedBusiness: Business!
    private var updateData: [String : Any?] = [:]
    var isImageEdited: Bool = false
    var isNameEdited: Bool {
        return defaultBusiness.name != editedBusiness.name
    }
    var isEmailEdited: Bool {
        return defaultBusiness.email != editedBusiness.email
    }
    var isPhoneNumberEdited: Bool {
        return defaultBusiness.phoneNumber != editedBusiness.phoneNumber
    }
    var isBusinessEdited: Bool {
        return isImageEdited || isNameEdited || isEmailEdited || isPhoneNumberEdited
    }
    var businessFB: BusinessFireBase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessFB = BusinessFireBase()
        // Do any additional setup after loading the view.
        self.title = K.UIConstant.account
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges(_:)))
        saveButton?.isEnabled = false
        accountStackView.logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editPhotoAction(_:))))
        accountStackView.nameTextField.delegate = self
        accountStackView.emailTextField.delegate = self
        accountStackView.numberTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpDefaultValues()
    }
    
    /// Assign the variables to the default values.
    private func setUpDefaultValues() {
        defaultBusiness = NSManagedObject.business
        editedBusiness = defaultBusiness
        image = defaultBusiness.logo == nil ? nil : UIImage(data: defaultBusiness.logo!)
        name = defaultBusiness.name
        email = defaultBusiness.email
        phoneNumber = defaultBusiness.phoneNumber
    }
    
    private func reloadEditable() {
        saveButton?.isEnabled = isBusinessEdited
    }
    
    @objc func editPhotoAction(_ gesture: UITapGestureRecognizer) {
        self.presentEditPhotoAlert(in: self, message: K.UIConstant.addBusinessLogoMessage)
    }
    
    @objc func saveChanges(_ sender: UIBarButtonItem) {
        //Update the cached business info.
        func finalize() throws {
            try self.editedBusiness.cache()
            self.navigationController?.popViewController(animated: true)
        }
        
        //Exhaustive execution.
        let execute: Promise<Void> = firstly {
            self.businessFB.updateBusiness(update: self.updateData, logoURL: self.editedBusiness.logoURL)
        }.done { (updateInfo) in
            let (result, _) = updateInfo
            if let imageURLInfo = result.data as? [String : String] {
                print(imageURLInfo)
                self.editedBusiness.logoURL = imageURLInfo[K.Key.logoURL]
            }
            try finalize()
        }
        
        func save() {
            self.startLoader { (loaderVC) in
                if self.isEmailEdited {
                    firstly {
                        self.businessFB.updateEmail(to: self.editedBusiness.email)
                    }.then {
                        execute
                    }.ensure(on: .main, {
                        loaderVC.stopLoader()
                    }).catch(on: .main) { (error) in
                        self.present(UIAlertController.internetConnectionAlert(actionHandler: save), animated: true)
                    }
                } else {
                    execute.ensure(on: .main, {
                        loaderVC.stopLoader()
                    }).catch(on: .main) { (error) in
                        self.present(UIAlertController.internetConnectionAlert(actionHandler: save), animated: true)
                    }
                }
            }
        }
        save()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        func logOut() {
            let cravyFB = CravyFirebase()
            
            self.startLoader { (loaderVC) in
                firstly {
                    cravyFB.signOut()
                }.done { (isSignedOut) in
                    if isSignedOut {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }.ensure {
                    loaderVC.stopLoader()
                }.catch { (error) in
                    self.present(UIAlertController.internetConnectionAlert(actionHandler: logOut), animated: true)
                }
            }
        }
        logOut()
    }
}

//MARK:- UITextField Delegate
extension AccountController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == accountStackView.emailTextField {
            return string != " "
        } else {
            return true
        }
    }
    
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
                name = defaultBusiness.name
            } else if textField == accountStackView.emailTextField {
                email = defaultBusiness.email
            } else if textField == accountStackView.numberTextField {
                phoneNumber = defaultBusiness.phoneNumber
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
        self.isImageEdited = true
        self.image = image
        editedBusiness.logo = image.jpegData(compressionQuality: 1)
    }
}
