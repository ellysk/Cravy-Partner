//
//  PopViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Lottie

/// Handles the display of important information or action that user is required to perform.
class PopViewController: UIViewController {
    private var popView: PopView
    private var animationView: AnimationView?
    private var action: (()->())?
    private var dismiss: (()->())?
    var loopMode: LottieLoopMode = .loop
    
    /// - Parameters:
    ///   - popView: Holds the views that display the actual information
    ///   - animationView: The view which displays the animation
    ///   - actionHandler: Called when user taps on the button displayed.
    ///   - dismissHandler: Called always when the view is dismissed.
    init(popView: PopView, animationView: AnimationView? = nil, actionHandler: (()->())? = nil, dismissHandler: (()->())? = nil) {
        self.popView = popView
        self.animationView = animationView
        self.action = actionHandler
        self.dismiss = dismissHandler
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popView.beginResponder = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView?.play()
        animationView?.loopMode = loopMode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        if touch.view == self.view {
            self.dismiss(animated: true, completion: dismiss)
        }
    }
    
    private func additionalSetup() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popView.actionButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        self.view.addSubview(popView)
        popView.translatesAutoresizingMaskIntoConstraints = false
        popView.widthAnchor(to: self.view, multiplier: 0.7)
        popView.centerXYAnchor(to: self.view)
        
        if let animationView = animationView {
            self.view.addSubview(animationView)
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.bottomAnchor.constraint(equalTo: popView.topAnchor, constant: 16).isActive = true
            animationView.sizeAnchorOf(width: 100, height: 100)
            animationView.centerXAnchor(to: self.view)
        }
    }
    
    @objc func action(_ sender: UIButton) {
        sender.pulse()
        self.dismiss(animated: true) {
            self.action?()
            self.dismiss?()
        }
    }
}
