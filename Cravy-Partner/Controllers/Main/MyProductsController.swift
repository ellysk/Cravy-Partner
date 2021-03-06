//
//  MyProductsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles search and display of the craves of both statuses.
class MyProductsController: UIViewController {
    @IBOutlet weak var searchBar: CravySearchBar!
    @IBOutlet weak var cravyToolBar: CravyToolBar!
    var selectedProduct: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.presentationDelegate = self
        self.view.setCravyGradientBackground()
        cravyToolBar.titles = [K.UIConstant.active, K.UIConstant.inactive]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toProductsPageVC {
            let productsPageVC = segue.destination as! ProductsPageController
            productsPageVC.transitionDelegate = self
            productsPageVC.scrollDelegate = self
            productsPageVC.presentationDelegate = self
            searchBar.delegate = productsPageVC
            cravyToolBar.delegate = productsPageVC
        } else if segue.identifier == K.Identifier.Segue.myProductsToProduct {
            guard let selected = selectedProduct else {return}
            let productVC = segue.destination as! ProductController
            productVC.productTitle = selected
        }
    }
}

//MARK:- Transition Delegate
extension MyProductsController: TransitionDelegate {
    func didTranisitionToViewAt(index: Int, pages: Int) {
        self.dismissKeyboard()
        cravyToolBar.isSelectedItemAt(index: index)
    }
    
    func goTo(direction: UIPageViewController.NavigationDirection) {}
}

//MARK:- ScrollView Delegate
extension MyProductsController: ScrollViewDelegate {
    func didScroll(scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
}

//MARK:- Presentation Delegate
extension MyProductsController: PresentationDelegate {
    func presentation(_ viewController: UIViewController, data: Any?) {
        self.dismissKeyboard()
        if let alertController = viewController as? UIAlertController {
            self.present(alertController, animated: true)
        }
    }
    
    func presentation(_ viewController: UIViewController.Type, data: Any?) {
        if viewController == ProductController.self {
            guard let data = data, let product = data as? String else {return}
            selectedProduct = product
            self.performSegue(withIdentifier: K.Identifier.Segue.myProductsToProduct, sender: self)
        } else if viewController == CravyTabBarController.self {
            guard let tab = self.tabBarController as? CravyTabBarController else {return}
            tab.selectedIndex = 1
        }
    }
}
