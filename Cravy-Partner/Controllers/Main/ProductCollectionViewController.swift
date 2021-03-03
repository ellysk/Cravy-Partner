//
//  ProductCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import Lottie
import SkeletonView
import PromiseKit

/// Handles the display of the products that the user has created.
class ProductCollectionViewController: CravyProductsController {
    
    override func reloadEmptyView() {
        if self.view.emptyView == nil {
            self.view.isEmptyView = self.products.isEmpty
            self.view.emptyView?.createButton.addTarget(self, action: #selector(self.startCreating(_:)), for: .touchUpInside)
            self.view.emptyView?.title = K.UIConstant.emptyProductsTitle
        } else {
            self.view.isEmptyView = self.products.isEmpty
        }
    }
    
    @objc func startCreating(_ sender: RoundButton) {
        sender.pulse()
        self.presentationDelegate?.presentation(CravyTabBarController.self, data: nil)
    }
}
