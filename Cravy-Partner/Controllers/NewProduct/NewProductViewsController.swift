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
    var delegate: PageViewsTransitionDelegate?
    
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
            self.delegate?.goTo(direction: .reverse)
        } else if sender.tag == 1 {
            self.delegate?.goTo(direction: .forward)
        }
    }
    
    @objc func create(_ sender: UIBarButtonItem) {
        let userDefault = UserDefaults.standard
        if userDefault.isProductInfoComplete {
            //TODO
        }
    }
    
    @IBAction func cancel(_ sender: RoundButton) {
        self.dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toNewProductPageVC {
            let newProductPageVC = segue.destination as! NewProductPageController
            self.delegate = newProductPageVC
            newProductPageVC.transitionDelegate = self
        }
    }
}

//MARK:- Transition Delegate
extension NewProductViewsController: TransitionDelegate {
    func didTranisitionToViewAt(index: Int) {
        //If index greater than 0, then user can go to previous view controller.
        previousItem.isEnabled = index > 0
        nextItem.title =  index < 2 ? K.UIConstant.next : "Create"
        nextItem.action = index < 2 ? #selector(navigate(_:)) : #selector(create(_:))
    }
}
