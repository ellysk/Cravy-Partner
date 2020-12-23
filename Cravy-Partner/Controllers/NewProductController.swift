//
//  NewProductController.swift
//  Cravy-Partner
//
//  Created by Cravy on 23/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import SwiftyCam
import Lottie

/// Handles the media representing the product.
class NewProductController: SwiftyCamViewController {
    @IBOutlet weak var galleryImageView: RoundImageView!
    @IBOutlet weak var utilityStackView: UIStackView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var captureButton: RoundBorderedButton!
    
    /// The animation played when user focuses on a specific point by tapping on the view once.
    let focusAnimation = AnimationView.focusAnimation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(focusAnimation)
        focusAnimation.frame.size = CGSize(width: 50, height: 50)
        cameraDelegate = self
        presetCamSettings()
        galleryImageView.roundFactor = 3.3
    }
    
    private func presetCamSettings() {
        self.pinchToZoom = true
        self.tapToFocus = true
        self.doubleTapCameraSwitch = true
    }
    
    /// Opens the user's device photos application content.
    @objc func openGallery(_ sender: UIImageView) {}
    
    @IBAction func utilityAction(_ sender: UIButton) {
        if sender == flashButton {
            //flash button is triggered
            let currentFlashMode = self.flashMode
            self.flashMode = currentFlashMode == .on ? .off : .on
            let bgimage = self.flashMode == .on ? K.Image.flashOn : K.Image.flashOff
            sender.setBackgroundImage(bgimage, for: .normal)
        } else if sender == switchCameraButton {
            //switch camera button is triggered
            self.switchCamera()
        }
    }
    
    
    /// Triggered when user initiates the action of taking a photo
    @IBAction func capture(_ sender: UIButton) {
        self.takePhoto()
    }
    
}

//MARK: - SwiftyCamViewControllerDelegate
extension NewProductController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusAnimation.play(at: point)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        //TODO
    }
}
