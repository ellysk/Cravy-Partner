//
//  IntroPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Displays multiple IntroControllers with different data provided to each one of them.
class IntroPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    /// The availabe view controllers that can be displayed.
    var pages: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = K.Collections.introSections
        let details = K.Collections.introSectionDetails
        pages = [IntroController(title: titles[0], detail: details[titles[0]]!), IntroController(title: titles[1], detail: details[titles[1]]!), IntroController(title: titles[2], detail: details[titles[2]]!)]
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: pageViewController.viewControllers![0])!
    }
}
