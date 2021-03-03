//
//  PRCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import PromiseKit

protocol PRCollectionViewControllerDelegate {
    func PRProductsDidFinishLoading(products: [Product])
}

/// Handles the display of collection of products that require certain actions.
class PRCollectionViewController: CravyProductsController {
    var PRDelegate: PRCollectionViewControllerDelegate?
    
    override init(state: PRODUCT_STATE) {
        super.init(state: state)
        self.collectionView.setCollectionViewLayout(UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout, animated: true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadCraves() {
        if products.isEmpty {
            isLoadingProducts = true
            
            firstly {
                productFB.loadProducts(callableFunction: "getPRProducts")
            }.done { (products) in
                self.products = products
            }.ensure(on: .main) {
                self.isLoadingProducts = false
                self.reloadEmptyView()
            }.catch { (error) in
                self.present(UIAlertController.internetConnectionAlert(actionHandler: self.loadCraves), animated: true)
            }
        }
    }
    
    override func reloadEmptyView() {
        self.PRDelegate?.PRProductsDidFinishLoading(products: products)
    }
}
