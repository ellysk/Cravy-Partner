//
//  ProductsPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import CoreData

/// Handles the display of products of different states.
class ProductsPageController: CravyPageController {
    var scrollDelegate: ScrollViewDelegate?
    var presentationDelegate: PresentationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [ProductCollectionViewController(state: .active), ProductCollectionViewController(state: .inActive)]
        pages.forEach { (controller) in
            //Assign delegates
            let productCollectionViewController = controller as! ProductCollectionViewController
            productCollectionViewController.scrollDelegate = scrollDelegate
            productCollectionViewController.presentationDelegate = presentationDelegate
            productCollectionViewController.delegate = self
        }
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        delegate = self
        dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add the newly created product
        guard let IDs = UserDefaults.standard.array(forKey: K.Key.newProducts) as? [String] else {return}
        do {
            let products = try NSManagedObject.products(ids: IDs)
            products.forEach { (product) in
                let productionCollectionViewController = pages.first { (viewController) -> Bool in
                    let productionCollectionVC = viewController as! ProductCollectionViewController
                    return productionCollectionVC.state == product.state
                } as! ProductCollectionViewController
                productionCollectionViewController.add(product)
            }
        } catch {
            return
        }
        
        deleteNewProductModels() //Remove the cached information of the newly created product
    }
    
    private func deleteNewProductModels() {
        guard let IDs = UserDefaults.standard.array(forKey: K.Key.newProducts) as? [String] else {return}
        do {
            let products = try NSManagedObject.products(ids: IDs)
            try products.forEach { (product) in
                try product.delete()
            }
            UserDefaults.standard.removeObject(forKey: K.Key.newProducts)
        } catch {
            return
        }
    }
    
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

//MARK:- CravySearchBar Delegate
extension ProductsPageController: CravySearchBarDelegate {
    func textDidChange(_ text: String) {
        enquire(text: text)
    }

    func didEnquireSearch(_ text: String) {
        enquire(text: text)
    }
    
    func didCancelSearch(_ searchBar: CravySearchBar) {
        enquire(text: nil)
    }
    
    func didSort(by sort: PRODUCT_SORT) {
        guard let productCollectionViewController = displayedController as? ProductCollectionViewController else {return}
        productCollectionViewController.sortProductsBy(sort: sort)
    }
    
    private func enquire(text: String?) {
        guard let productCollectionViewController = displayedController as? ProductCollectionViewController else {return}
        productCollectionViewController.searchForProductWith(query: text)
    }
}

//MARK:- Product Delegate
extension ProductsPageController: ProductDelegate {
    func didCreateProduct(_ product: Product) {
        guard let inActiveProductsVC = pages[1] as? ProductCollectionViewController else {return}
        inActiveProductsVC.add(product)
    }
    
    func didSelectProduct(_ product: Product, at indexPath: IndexPath?) {}
    
    func didPostProduct(_ product: Product, at indexPath: IndexPath?) {
        guard let productCollectionViewControllers = pages as? [ProductCollectionViewController] else {return}
        let (activeProductsVC, inActiveProductsVC) = (productCollectionViewControllers[0], productCollectionViewControllers[1])
        inActiveProductsVC.remove(product)
        activeProductsVC.add(product)
    }
    
    func didPullProduct(_ product: Product) {
        guard let productCollectionViewControllers = pages as? [ProductCollectionViewController] else {return}
        let (activeProductsVC, inActiveProductsVC) = (productCollectionViewControllers[0], productCollectionViewControllers[1])
        inActiveProductsVC.add(product)
        activeProductsVC.remove(product)
    }
    
    func didEditProduct(_ product: Product) {
        guard let productCollectionViewController = displayedController as? ProductCollectionViewController else {return}
        productCollectionViewController.edit(product)
    }
    
    func didDeleteProduct(_ product: Product) {
        guard let productCollectionViewController = displayedController as? ProductCollectionViewController else {return}
        productCollectionViewController.remove(product)
    }
}
