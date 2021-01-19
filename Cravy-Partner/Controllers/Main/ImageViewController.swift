//
//  ImageViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 07/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import Photos

protocol ImageViewControllerDelegate {
    func didConfirmImage(_ image: UIImage)
}

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var confirmButton: FloaterView!
    var image: UIImage!
    var dismissAfterConfirmAction: Bool = false
    private var cravyPartnerAlbum: PHAssetCollection? = PHFetchOptions().cravyPartnerAlbum
    var isLandscape: Bool = false
    var delegate: ImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        if isLandscape {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
        imageView.image = image
        imageView.roundFactor = 30
        imageView.cornerMask = UIView.bottomCornerMask
        confirmButton.image = UIImage(systemName: "checkmark.circle.fill")
        confirmButton.title = K.UIConstant.confirm
        confirmButton.delegate = self
    }
    
    private func saveImage() {
        cravyPartnerAlbum!.addImage(image) { (completed, error) in
            if let e = error {
                fatalError("Could not save image to album: Error -> \(e.localizedDescription)")
            } else if completed {
                //TODO
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        //TODO
        self.dismiss(animated: true)
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
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
        if segue.identifier == K.Identifier.Segue.imageViewToNewProductViews {
            let newProductViewController = segue.destination as! NewProductViewsController
            newProductViewController.bgImage = image
        }
    }
}

//MARK:- FloaterView Delegate
extension ImageViewController: FloaterViewDelegate {
    func didTapFloaterButton(_ floaterView: FloaterView) {
        if dismissAfterConfirmAction {
            self.dismiss(animated: true) {
                self.delegate?.didConfirmImage(self.image)
            }
        } else {
            self.performSegue(withIdentifier: K.Identifier.Segue.imageViewToNewProductViews, sender: self)
        }
    }
}
