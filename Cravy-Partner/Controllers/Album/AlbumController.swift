//
//  AlbumController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of different types of collection of photos in the user's photo library.
class AlbumController: UIViewController {
    @IBOutlet weak var cravyToolBar: CravyToolBar!
    var selectedImage: UIImage?
    /// A boolean that determines if the user is currently editing the product.
    var isUserEditingProduct: Bool = false
    var imageViewDelegate: ImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.showsDismissButton = true
        self.view.setCravyGradientBackground()
        cravyToolBar.titles = [K.UIConstant.albumTitle, K.UIConstant.cameraRoll]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toAlbumPageController {
            let albumPageController = segue.destination as! AlbumPageController
            albumPageController.transitionDelegate = cravyToolBar
            albumPageController.presentationDelegate = self
            cravyToolBar.delegate = albumPageController
        } else if segue.identifier == K.Identifier.Segue.albumToNewProduct {
            let newProductViewsController = segue.destination as! NewProductViewsController
            newProductViewsController.bgImage = selectedImage
        }
    }
}

//MARK:- Presentation Delegate
extension AlbumController: PresentationDelegate {
    func willPresent(_ viewController: UIViewController?, data: Any?) {
        self.view.isUserInteractionEnabled = false //avoid user interacting with other views when preparing to perform segue
        guard let data = data, let image = data as? UIImage else {return}
        if isUserEditingProduct {
            self.dismiss(animated: true) {
                self.imageViewDelegate?.didConfirmImage(image)
            }
        } else {
            selectedImage = image
            performSegue(withIdentifier: K.Identifier.Segue.albumToNewProduct, sender: self)
        }
        self.view.isUserInteractionEnabled = true
    }
}
