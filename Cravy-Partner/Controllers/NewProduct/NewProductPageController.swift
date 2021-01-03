//
//  NewProductPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of view controllers that allow user to input product information.
class NewProductPageController: CravyPageController, PageViewsTransitionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [K.Controller.textsViewController, K.Controller.tagsCollectionViewController, K.Controller.linkViewController]
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        delegate = self
    }
    
    override func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK:- PageViewsTransition Delegate
    func goTo(direction: UIPageViewController.NavigationDirection) {
        guard let currentIndex = pages.firstIndex(of: (self.viewControllers?.first)!) else {return}
        var newIndex = currentIndex
        if direction == .forward && currentIndex < pages.count - 1 {
            newIndex+=1
            self.setViewControllers([pages[newIndex]], direction: direction, animated: true)
        } else if direction == .reverse && currentIndex > 0 {
            newIndex-=1
            self.setViewControllers([pages[newIndex]], direction: direction, animated: true)
        }
        self.transitionDelegate?.didTranisitionToViewAt(index: newIndex)
    }
}
