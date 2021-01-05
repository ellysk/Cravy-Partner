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

enum SESSION {
    case running
    case stop
}

/// Handles the media representing the product.
class NewProductController: SwiftyCamViewController {
    @IBOutlet weak var galleryImageView: RoundImageView!
    @IBOutlet weak var cancelButton: RoundButton!
    @IBOutlet weak var utilityStackView: UIStackView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var saveButton: RoundButton!
    @IBOutlet weak var captureButton: RoundBorderedButton!
    var capturedImage: UIImage?
    var sessionState: SESSION {
        set {
            self.pinchToZoom = newValue == .running
            self.tapToFocus = newValue == .running
            galleryImageView.isHidden = newValue == .stop
            cancelButton.isHidden = newValue == .running
            utilityStackView.isHidden = newValue == .stop
            saveButton.isHidden = newValue == .running
            captureButton.isHidden = newValue == .stop
            self.floaterView?.isHidden = newValue == .running
            if newValue == .running {
                if !self.session.isRunning {
                    self.session.startRunning()
                }
            } else {
                self.session.stopRunning()
                self.setFloaterViewWith(image: UIImage(systemName: "arrow.right.circle.fill")!, title: K.UIConstant.next)
                self.floaterView?.delegate = self
            }
        }
        
        get {
            if self.session.isRunning {
                return .running
            } else {
                return .stop
            }
        }
    }
    /// The animation played when user focuses on a specific point by tapping on the view once.
    let focusAnimation = AnimationView.focusAnimation
    private var cravyPartnerAlbum: PHAssetCollection? = PHFetchOptions().cravyPartnerAlbum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        additionalSetup()
        cameraDelegate = self
        self.view.addSubview(focusAnimation)
        focusAnimation.frame.size = CGSize(width: 50, height: 50)
        galleryImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery(_:))))
        galleryImageView.roundFactor = 3.3
    }
    
    
    private func additionalSetup() {
        self.pinchToZoom = true
        self.tapToFocus = true
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
        saveButton.setBackgroundImage(UIImage(systemName: "square.and.arrow.down.fill")?.withInset(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)), for: .normal)
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
    
    private func saveImage() {
        cravyPartnerAlbum!.addImage(capturedImage!) { (completed, error) in
            if let e = error {
                fatalError("Could not save image to album: Error -> \(e.localizedDescription)")
            } else if completed {
                //TODO
            }
        }
    }
    
    /// Opens the user's device photos application content.
    @objc func openGallery(_ sender: UIImageView) {
        performSegue(withIdentifier: K.Identifier.Segue.newProductToAlbum, sender: self)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        sessionState = .running
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
    
    /// Triggered when user initiates the action of taking a photo
    @IBAction func capture(_ sender: UIButton) {
        self.takePhoto()
    }
    
    @IBAction func saveToCravyPartnerAlbum(_ sender: UIButton) {
        if cravyPartnerAlbum != nil {
            saveImage()
        } else {
            //Create Cravy Partner album
            let photoLibrary = PHPhotoLibrary.shared()
            photoLibrary.createAssetCollectionWithTitle(title: K.UIConstant.albumTitle) { (completed, error) in
                if let e = error {
                    fatalError("Could not make album: Error -> \(e.localizedDescription)")
                } else if completed {
                    self.saveImage()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.newProductToNewProductViews {
            let newProductViewsController = segue.destination as! NewProductViewsController
            newProductViewsController.bgImage = capturedImage
        }
    }
}

//MARK:- SwiftyCamViewControllerDelegate
extension NewProductController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusAnimation.play(at: point)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        capturedImage = photo
        sessionState = .stop
    }
}

//MARK:- FloaterView Delegate
extension NewProductController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        performSegue(withIdentifier: K.Identifier.Segue.newProductToNewProductViews, sender: self)
    }
}
