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
class NewProductViewsController: UIViewController, TransitionDelegate {
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var previousItem: UIBarButtonItem!
    @IBOutlet weak var actionButton: RoundButton!
    var bgImage: UIImage!
    var delegate: PageViewsTransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        bgImageView.image = bgImage
        bgImageView.isBlurr = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        previousItem.isEnabled = false
        actionButton.castShadow = true
    }
    
    @IBAction func previous(_ sender: UIBarButtonItem) {
        self.delegate?.goTo(direction: .reverse)
    }
    
    @IBAction func action(_ sender: RoundButton) {
        self.delegate?.goTo(direction: .forward)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifier.Segue.toNewProductPageVC {
            let newProductPageVC = segue.destination as! NewProductPageController
            self.delegate = newProductPageVC
            newProductPageVC.transitionDelegate = self
        }
    }
    
    //MARK:- Transition Delegate
    func didTranisitionToViewAt(index: Int) {
        //If index greater than 0, then user can go to previous view controller.
        previousItem.isEnabled = index > 0
    }
}
