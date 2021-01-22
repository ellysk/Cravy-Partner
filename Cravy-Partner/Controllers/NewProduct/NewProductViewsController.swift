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

/// Handles the transitions of the NewsPageController
class NewProductViewsController: UIViewController {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var previousItem: UIBarButtonItem!
    @IBOutlet weak var nextItem: UIBarButtonItem!
    var bgImage: UIImage!
    var isProductInfoComplete: Bool {
        guard let _ = productInfo[K.Key.image] as? UIImage, let _ = productInfo[K.Key.title] as? String, let _ = productInfo[K.Key.description] as? String, let _ = productInfo[K.Key.tags] as? [String] else {return false}
        return true
    }
    var productInfo: [String:Any]!
    var transitionDelegate: PageViewsTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //set the first info of the product [image]
        productInfo = [K.Key.image : bgImage!]
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
        if isProductInfoComplete {
            performSegue(withIdentifier: K.Identifier.Segue.newProductToProduct, sender: self)
        }
    }
    
    @IBAction func cancel(_ sender: RoundButton) {
        self.dismissVC()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toNewProductPageVC {
            let newProductPageVC = segue.destination as! NewProductPageController
            self.transitionDelegate = newProductPageVC
            newProductPageVC.productInfoDelegate = self
            newProductPageVC.transitionDelegate = self
        } else if segue.identifier == K.Identifier.Segue.newProductToProduct {
            let productVC = segue.destination as! ProductController
            productVC.navigationItem.setHidesBackButton(true, animated: true)
            productVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: productVC, action: #selector(productVC.done(_:)))
            productVC.productTitle = productInfo[K.Key.title] as? String
        }
    }
}

//MARK:- ProductInfo Delegate
extension NewProductViewsController: ProductInfoDelegate {
    func didConfirmProductTitle(_ title: String) {
        productInfo.updateValue(title, forKey: K.Key.title)
    }
    
    func didConfirmProductDescription(_ description: String) {
        productInfo.updateValue(description, forKey: K.Key.description)
    }
    
    func didConfirmProductTags(_ tags: [String]) {
        productInfo.updateValue(tags, forKey: K.Key.tags)
    }
    
    func didConfirmProductLink(_ link: String?) {
        guard let link = link else {return}
        productInfo.updateValue(link, forKey: K.Key.url)
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
