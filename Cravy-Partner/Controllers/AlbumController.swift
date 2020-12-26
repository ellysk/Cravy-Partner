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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setCravyGradientBackground()
        cravyToolBar.titles = [K.UIConstant.albumTitle, K.UIConstant.allPhotos]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toAlbumPageController {
            let albumPageController = segue.destination as! AlbumPageController
            albumPageController.transitionDelegate = self
            cravyToolBar.delegate = albumPageController
        }
    }
}


//MARK: - CravyPageController Delegate
extension AlbumController: TransitionDelegate {
    func didTranisitionToViewAt(index: Int) {
        cravyToolBar.isSelectedItemAt(index: index)
    }
}
