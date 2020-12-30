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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        additionalSetup()
    }
    
    /// - Parameters:
    ///   - popView: Holds the views that display the actual information
    init(popView: PopView, animationView: AnimationView? = nil) {
        self.popView = popView
        self.animationView = animationView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func additionalSetup() {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView?.play()
        animationView?.loopMode = .repeat(2)
    }
}
