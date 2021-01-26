//
//  NewProductPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
/// Called to notify that the user has completed the new information about the product.
protocol ProductInfoDelegate {
    func didConfirmProductTitle(_ title: String)
    func didConfirmProductDescription(_ description: String)
    func didConfirmProductTags(_ tags: [String])
    func didConfirmProductLink(_ link: String?)
}

/// Handles the display of view controllers that allow user to input product information.
class NewProductPageController: CravyPageController {
    var productInfoDelegate: ProductInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [TextInputController(), TagsInputController(), LinkInputController()]
        //Set the delegates
        pages.forEach { (viewController) in
            if let NPController = viewController as? NPViewController {
                NPController.productInfoDelegate = productInfoDelegate
            } else if let NPCollectionController = viewController as? NPCollectionViewController {
                NPCollectionController.productInfoDelegate = productInfoDelegate
            }
        }
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
                        presentFillAlert()
                    }
                }
            } else if let collectionViewController = displayedController as? NPCollectionViewController {
                collectionViewController.confirmNewProductInput { (isInputValid) in
                    if isInputValid {
                        super.go(direction)
                    } else {
                        presentFillAlert()
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
    
    /// An alert prompt to notify the user that some inputs have not been completed.
    private func presentFillAlert() {
        let alertController = UIAlertController(title: nil, message: K.UIConstant.fillAlertMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: K.UIConstant.OK, style: .cancel, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true)
    }
}

class NPViewController: UIViewController {
    var productInfoDelegate: ProductInfoDelegate?
    
    func confirmNewProductInput(confirmationHandler: (Bool)->()) {
        confirmationHandler(true)
    }
}

class NPCollectionViewController: UICollectionViewController {
    var productInfoDelegate: ProductInfoDelegate?
    
    func confirmNewProductInput(confirmationHandler: (Bool)->()) {
        confirmationHandler(true)
    }
}
