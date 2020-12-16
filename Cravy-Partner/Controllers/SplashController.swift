//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

enum SPLASH {
    case intro
    case auth
}

/// Displays the IntroPageController in a container view and handles authentication of the user.
class SplashController: UIViewController {
    @IBOutlet weak var pageController: UIView!
    @IBOutlet weak var getStartedButton: RoundBorderedButton!
    var authStackView = AuthStackView()
    @IBOutlet weak var noticeLabel: UILabel!
    /// Determines the state of the view controller. if intro then the controller displays the IntroPageController otherwise the AuthStackView is displayed.
    var splash: SPLASH {
        set {
            pageController.isHidden = newValue == .auth
            getStartedButton.isHidden = newValue == .auth
            authStackView.isHidden = newValue == .intro
            noticeLabel.isHidden = newValue == .intro
        }
        
        get {
            if pageController.isHidden && getStartedButton.isHidden {
                return .auth
            } else {
                return .intro
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splash = .intro
        setAuthStackView()
    }
    
    private func setAuthStackView() {
        self.view.addSubview(authStackView)
        authStackView.translatesAutoresizingMaskIntoConstraints = false
        authStackView.centerYAnchor(to: self.view)
        authStackView.HConstraint(to: self.view, constant: 8)
    }
    
    @IBAction func getStarted(_ sender: UIButton) {
        splash = .auth
    }
}
