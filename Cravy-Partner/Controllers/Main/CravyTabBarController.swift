//
//  CravyTabBarController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class CravyTabBarController: UITabBarController {
    var PRProducts: [Product]? {
        guard let myProductsController = self.viewControllers?.first(where: { (viewController) -> Bool in
            return viewController as? MyProductsController != nil
        }) as? MyProductsController, let inactiveProductCollectionVC = myProductsController.productsPageController.pages.first(where: { (viewController) -> Bool in
            let productCollectionVC = viewController as! ProductCollectionViewController
            return productCollectionVC.state == .inActive
        }) as? ProductCollectionViewController else {return nil}
        return inactiveProductCollectionVC.products.filter { (product) -> Bool in
            guard let diff = Calendar.current.dateComponents([.hour], from: product.date, to: Date()).hour else {return false}
            return diff > 24
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var imageInfo: [String : UIImage]? {
        guard let myProductsController = self.viewControllers?.first(where: { (viewController) -> Bool in
            return viewController as? MyProductsController != nil
        }) as? MyProductsController, let productCollectionVCs = myProductsController.productsPageController.pages as? [ProductCollectionViewController] else {return nil}
        var info: [String : UIImage] = [:]
        productCollectionVCs.forEach { (productCollectionVC) in
            productCollectionVC.products.forEach { (product) in
                guard let image = UIImage(data: product.image) else {return}
                info.updateValue(image, forKey: product.id)
            }
        }
        
        return info
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = K.Color.light
    }
}
