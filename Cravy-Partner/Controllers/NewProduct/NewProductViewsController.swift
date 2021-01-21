//
//  NewProductViewsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

protocol PageViewsTransitionDelegate {
    func goTo(direction: UIPageViewController.NavigationDirection)
}

protocol NewProductViewsControllerDelegate {
    func didCreateProduct()
}

/// Handles the transitions of the NewsPageController
class NewProductViewsController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var previousItem: UIBarButtonItem!
    @IBOutlet weak var nextItem: UIBarButtonItem!
    var bgImage: UIImage!
    var transitionDelegate: PageViewsTransitionDelegate?
    var delegate: NewProductViewsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bgImageView.image = bgImage
        bgImageView.isBlurr = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        previousItem.isEnabled = false
    }
    
    @IBAction func navigate(_ sender: UIBarButtonItem) {
        if sender.tag == -1 {
            self.transitionDelegate?.goTo(direction: .reverse)
        } else if sender.tag == 1 {
            self.transitionDelegate?.goTo(direction: .forward)
        }
    }
    
    @objc func create(_ sender: UIBarButtonItem) {
        UserDefaults.standard.addImage(bgImage)
        if UserDefaults.standard.isProductInfoComplete {
            performSegue(withIdentifier: K.Identifier.Segue.newProductToProduct, sender: self)
            self.delegate?.didCreateProduct()
        }
    }
    
    @IBAction func cancel(_ sender: RoundButton) {
        dismissNewProductViewsController()
    }
    
    private func dismissNewProductViewsController(dismissHandler: (()->())? = nil) {
        self.dismiss(animated: true) {
            dismissHandler?()
            UserDefaults.standard.deleteProductInfo()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toNewProductPageVC {
            let newProductPageVC = segue.destination as! NewProductPageController
            self.transitionDelegate = newProductPageVC
            newProductPageVC.transitionDelegate = self
        } else if segue.identifier == K.Identifier.Segue.newProductToProduct {
            let productVC = segue.destination as! ProductController
            self.delegate = productVC
            productVC.productTitle = UserDefaults.standard.string(forKey: UserDefaults.titleKey)
        }
    }
}

//MARK:- Transition Delegate
extension NewProductViewsController: TransitionDelegate {
    func didTranisitionToViewAt(index: Int, pages: Int) {
        //If index greater than 0, then user can go to previous view controller.
        previousItem.isEnabled = index > 0
        let maxPageCount = pages - 1
        nextItem.title =  index < maxPageCount ? K.UIConstant.next : K.UIConstant.create
        nextItem.action = index < maxPageCount ? #selector(navigate(_:)) : #selector(create(_:))
    }
}
