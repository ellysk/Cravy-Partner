//
//  AlbumPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import Photos

/// Displays different collections of photos in the user's library.
class AlbumPageController: CravyPageController {
    var presentationDelegate: PresentaionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [AlbumCollectionViewController(result: PHFetchOptions().cravyPartnerAssets), AlbumCollectionViewController(result: PHFetchOptions().allPhotos)]
        pages.forEach { (controller) in
            let albumCollectionViewController = controller as! AlbumCollectionViewController
            albumCollectionViewController.presentationDelegate = presentationDelegate
        }
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
    }
    
    //override to hide the UIPageControl
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

