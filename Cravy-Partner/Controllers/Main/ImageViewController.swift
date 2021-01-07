//
//  ImageViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 07/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import Photos

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    private var cravyPartnerAlbum: PHAssetCollection? = PHFetchOptions().cravyPartnerAlbum
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = image
        self.setFloaterViewWith(image: UIImage(systemName: "arrow.right.circle.fill")!, title: K.UIConstant.next)
        self.floaterView?.delegate = self
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
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //TODO
        self.dismiss(animated: true)
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIBarButtonItem) {
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
        performSegue(withIdentifier: K.Identifier.Segue.imageViewToNewProductViews, sender: self)
    }
}
