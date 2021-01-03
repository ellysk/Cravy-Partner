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
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [AlbumCollectionViewController(result: PHFetchOptions().cravyPartnerAssets), AlbumCollectionViewController(result: PHFetchOptions().allPhotos)]
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
    }
    
    //override to hide the UIPageControl
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

//MARK: - CravyToolBar Delegate
extension AlbumPageController: CravyToolBarDelegate {
    func itemSelected(at index: Int) {
        let currentIndex = self.presentationIndex(for: self)
        if index != currentIndex {
            let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
            self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
        }
    }
}
