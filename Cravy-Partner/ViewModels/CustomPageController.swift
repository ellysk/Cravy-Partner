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

//MARK: - CravyToolBar Delegate
extension CravyPageController: CravyToolBarDelegate {
    func itemSelected(at index: Int) {
        let currentIndex = self.presentationIndex(for: self)
        if index != currentIndex {
            let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
            self.setViewControllers([pages[index]], direction: direction, animated: true) { (completed) in
                if completed {
                    self.transitionDelegate?.didTranisitionToViewAt(index: self.presentationIndex(for: self))
                }
            }
        }
    }
}

//MARK:- PageViewsTransition Delegate
extension CravyPageController: PageViewsTransitionDelegate {
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
