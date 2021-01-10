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
        self.cravyPCDelegate?.didFinishLoadingPages(pages: pages)
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        delegate = self
    }
    
    override func go(_ direction: UIPageViewController.NavigationDirection) {
        if direction == .forward {
            if let viewController = displayedController as? NPViewController {
                viewController.confirmNewProductInput { (isInputValid) in
                    if isInputValid {
                        super.go(direction)
                    } else {
                        print("No pass bitch!")
                    }
                }
            } else if let collectionViewController = displayedController as? NPCollectionViewController {
                collectionViewController.confirmNewProductInput { (isInputValid) in
                    if isInputValid {
                        super.go(direction)
                    } else {
                        print("No pass bitch!")
                    }
                }
            }
        } else {
            super.go(direction)
        }
    }
    
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class NPViewController: UIViewController {
    func confirmNewProductInput(confirmationHandler: (Bool)->()) {
        confirmationHandler(true)
    }
}

class NPCollectionViewController: UICollectionViewController {
    func confirmNewProductInput(confirmationHandler: (Bool)->()) {
        confirmationHandler(true)
    }
}
