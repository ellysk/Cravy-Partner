//
//  NewProductPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of view controllers that allow user to input product information.
class NewProductPageController: CravyPageController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [K.Controller.textsViewController, K.Controller.tagsCollectionViewController, K.Controller.linkViewController]
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        delegate = self
    }
    
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
