//
//  ProductsPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of products of different states.
class ProductsPageController: CravyPageController {
    var scrollDelegate: ScrollViewDelegate?
    var presentationDelegate: PresentaionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [ProductCollectionViewController(state: .active), ProductCollectionViewController(state: .inActive)]
        pages.forEach { (controller) in
            //Assign delegates
            let productCollectionViewController = controller as! ProductCollectionViewController
            productCollectionViewController.scrollDelegate = scrollDelegate
            productCollectionViewController.presentationDelegate = presentationDelegate
        }
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        delegate = self
        dataSource = self
    }
    
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
