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
import Photos
import UIImageColors

/// Handles the media representing the product.
class NewProductController: SwiftyCamViewController {
    @IBOutlet weak var galleryImageView: RoundImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var utilityStackView: UIStackView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var captureButton: RoundBorderedButton!
    var capturedImage: UIImage?
    /// The animation played when user focuses on a specific point by tapping on the view once.
    let focusAnimation = AnimationView.focusAnimation
    var isUserEditingProduct: Bool = false
    /// Determines if the photo was taken whe the device orientation was at lanscape.
    var isLandscape: Bool {
        guard let image = capturedImage else {return false}
        return image.size.width > image.size.height
    }
    var imageViewDelegate: ImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraDelegate = self
        galleryImageView.isHidden = isUserEditingProduct
        cancelButton.isHidden = !isUserEditingProduct
        if !isUserEditingProduct {
            galleryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery(_:))))
            galleryImageView.roundFactor = 3.3
        }
        self.view.addSubview(focusAnimation)
        focusAnimation.frame.size = CGSize(width: 50, height: 50)
        additionalSetup()
    }
    
    private func additionalSetup() {
        self.pinchToZoom = true
        self.tapToFocus = true
        self.shouldUseDeviceOrientation = true
        self.doubleTapCameraSwitch = false
        if !isUserEditingProduct {
            self.checkPhotoLibraryPermission { (isPermitted) in
                if !isPermitted {
                    self.present(UIAlertController.photoLibrayAccessAlert, animated: true)
                } else {
                    let fetchOptions = PHFetchOptions()
                    if let album = fetchOptions.cravyPartnerAlbum {
                        self.fetchImageFrom(album)
                    }
                }
            }
        }
    }
    
    /// Fetch an asset in the Cravy partner asset collection and assigns it to the gallery image view.
    private func fetchImageFrom(_ album: PHAssetCollection) {
        let assets = album.fetchAssets()
        guard let asset = assets.firstObject else {return}
        asset.fetchImage(targetSize: galleryImageView.bounds.size) { (fetchedImage, info) in
            self.galleryImageView.image = fetchedImage
            self.galleryImageView.isUserInteractionEnabled = true
        }
    }
    
    /// Opens the user's device photos application content.
    @objc func openGallery(_ sender: UIImageView) {
        performSegue(withIdentifier: K.Identifier.Segue.newProductToAlbum, sender: self)
    }
    
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
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    /// Triggered when user initiates the action of taking a photo
    @IBAction func capture(_ sender: UIButton) {
        self.takePhoto()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.newProductToImageView {
            let nav = segue.destination as! UINavigationController
            let imageViewController = nav.viewControllers.first as! ImageViewController
            imageViewController.image = capturedImage
            imageViewController.isLandscape = isLandscape
            imageViewController.delegate = self
            imageViewController.dismissAfterConfirmAction = isUserEditingProduct
        }
    }
}

//MARK:- SwiftyCamViewController Delegate
extension NewProductController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusAnimation.play(at: point)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        capturedImage = photo
        self.performSegue(withIdentifier: K.Identifier.Segue.newProductToImageView, sender: self)
    }
}

//MARK:- ImageViewController Delegate
extension NewProductController: ImageViewControllerDelegate {
    func didConfirmImage(_ image: UIImage) {
        self.dismiss(animated: true) {
            self.imageViewDelegate?.didConfirmImage(image)
        }
    }
}
