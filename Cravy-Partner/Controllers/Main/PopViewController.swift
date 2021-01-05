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
    
    /// - Parameters:
    ///   - popView: Holds the views that display the actual information
    init(popView: PopView, animationView: AnimationView? = nil, actionHandler: (()->())? = nil) {
        self.popView = popView
        self.animationView = animationView
        self.action = actionHandler
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView?.play()
        animationView?.loopMode = .loop
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        if touch.view == self.view {
            self.dismiss(animated: true)
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
        self.dismiss(animated: true) {
            self.action?()
        }
    }
}
