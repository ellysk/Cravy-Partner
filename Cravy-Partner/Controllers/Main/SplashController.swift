//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit

enum SPLASH {
    case intro
    case auth
}

/// Displays the IntroPageController in a container view and handles authentication of the user.
class SplashController: UIViewController {
    @IBOutlet weak var pageController: UIView!
    @IBOutlet weak var getStartedButton: RoundBorderedButton!
    @IBOutlet weak var authStackView: AuthStackView!
    @IBOutlet weak var noticeLabel: UILabel!
    /// Determines the state of the view controller. if intro then the controller displays the IntroPageController otherwise the AuthStackView is displayed.
    var splash: SPLASH {
        set {
            pageController.isHidden = newValue == .auth
            getStartedButton.isHidden = newValue == .auth
            authStackView.isHidden = newValue == .intro
            noticeLabel.isHidden = newValue == .intro
            
            authStackView.beginResponder = !authStackView.isHidden
            
            businessFB = newValue == .auth ? BusinessFireBase() : nil
        }
        
        get {
            if pageController.isHidden && getStartedButton.isHidden {
                return .auth
            } else {
                return .intro
            }
        }
    }
    var businessFB: BusinessFireBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splash = .intro
        authStackView.emailTextField.delegate = self
        authStackView.passwordTextField.delegate = self
        authStackView.authButton.addTarget(self, action: #selector(auth(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func login() {
        //TODO
        self.view.isUserInteractionEnabled = false
        authStackView.authButton.startAnimation()
        
        let email = authStackView.emailTextField.text!
        let password = authStackView.passwordTextField.text!
        
        firstly {
            //Login
            businessFB!.signIn(email: email, password: password)
        }.then { (result) in
            //Fetch the business information
            self.businessFB!.loadBusiness()
        }.done(on: .main, { (business) in
            //Cache the business information
            let userDefaults = UserDefaults.standard
            userDefaults.set(business.businessInfo!, forKey: business.id)
            
            self.authStackView.authButton.stopAnimation(animationStyle: .expand, revertAfterDelay: 0.0) {
                self.performSegue(withIdentifier: K.Identifier.Segue.splashToCravyTabBar, sender: self)
            }
        }).ensure {
            self.view.isUserInteractionEnabled = true
            self.authStackView.resignFirstResponders()
        }.catch { (error) in
            self.authStackView.authButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.0) {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    self.present(UIAlertController.errorAlert(message: errCode.description), animated: true)
                } else {
                    self.present(UIAlertController.errorAlert(message: AuthErrorCode.networkError.description), animated: true)
                }
            }
        }
    }
    
    @IBAction func getStarted(_ sender: UIButton) {
        splash = .auth
    }
    
    @objc private func auth(_ sender: RoundTransitionButton) {
        authStackView.resignFirstResponders()
        if !authStackView.isFullFields {
            sender.shake()
        } else {
            login()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.splashToCravyTabBar {
            let transition: CATransition = CATransition()
            transition.type = CATransitionType.fade
            navigationController?.view.layer.add(transition, forKey: nil)
        }
    }
}

//MARK:- UITextField Delegate
extension SplashController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == authStackView.emailTextField {
            return string != " "
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            authStackView.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
