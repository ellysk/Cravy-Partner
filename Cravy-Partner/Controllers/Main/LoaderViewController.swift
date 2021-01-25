//
//  LoaderViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 25/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import Lottie

/// Handles the display of a loader animation which indicates that the application is waiting for a response from a network request.
class LoaderViewController: UIViewController {
    private let loaderAnimation = AnimationView.loaderAnimation
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setLoaderAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loaderAnimation.loopMode = .loop
        loaderAnimation.play()
    }
    
    private func setLoaderAnimation() {
        self.view.addSubview(loaderAnimation)
        loaderAnimation.translatesAutoresizingMaskIntoConstraints = false
        loaderAnimation.centerXYAnchor(to: self.view)
        loaderAnimation.sizeAnchorOf(width: 50, height: 50)
    }
    
    func stopLoader(completion: (()->())? = nil) {
        self.dismiss(animated: true) {
            self.loaderAnimation.stop()
            completion?()
        }
    }
}
