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
    var delegate: PageViewsTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.view.setCravyGradientBackground()
        cravyToolBar.titles = [K.UIConstant.active, K.UIConstant.inactive]
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toProductsPageVC {
            let productsPageVC = segue.destination as! ProductsPageController
            productsPageVC.transitionDelegate = self
            productsPageVC.scrollDelegate = self
            productsPageVC.presentationDelegate = self
            cravyToolBar.delegate = productsPageVC
        }
    }
}

//MARK:- CravySearchBar Delegate
extension MyProductsController: CravySearchBarDelegate {
    func willPresentFilterAlertController(alertController: UIAlertController) {
        self.dismissKeyboard()
        self.present(alertController, animated: true)
    }
}

//MARK:- Transition Delegate
extension MyProductsController: TransitionDelegate {
    func didTranisitionToViewAt(index: Int) {
        self.dismissKeyboard()
        cravyToolBar.isSelectedItemAt(index: index)
    }
}

//MARK:- ScrollView Delegate
extension MyProductsController: ScrollViewDelegate {
    func didScroll(scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
}

//MARK:- Presentation Delegate
extension MyProductsController: PresentaionDelegate {
    func willPresent(_ viewController: UIViewController) {
        self.dismissKeyboard()
    }
}
