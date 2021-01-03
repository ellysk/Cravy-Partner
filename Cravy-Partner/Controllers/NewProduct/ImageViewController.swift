//
//  ImageViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 28/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos

/// Handles the display of the image taken by the user from the camera.
class ImageViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: RoundImageView!
    @IBOutlet weak var nextButon: RoundButton!
    var image: UIImage!
    private var cravyPartnerAlbum: PHAssetCollection? {
        return PHFetchOptions().cravyPartnerAlbum
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = image
        imageView.roundFactor = 30
        nextButon.castShadow = true
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
}
