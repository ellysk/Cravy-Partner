//
//  CustomPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

protocol TransitionDelegate {
    func didTranisitionToViewAt(index: Int)
}

/// A custom page controller with pre defined properties and methods for handling a UIPageViewController.
class CravyPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    /// The availabe view controllers that can be displayed.
    var pages: [UIViewController]!
    var transitionDelegate: TransitionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - UIPageController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentPage = pages.firstIndex(of: viewController)!
        
        if currentPage == 0 {
            return nil
        } else {
            return pages[currentPage - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentPage = pages.firstIndex(of: viewController)!

        if currentPage == pages.count - 1 {
            return nil
        } else {
            return pages[currentPage + 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.transitionDelegate?.didTranisitionToViewAt(index: self.presentationIndex(for: pageViewController))
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: pageViewController.viewControllers![0])!
    }
}
