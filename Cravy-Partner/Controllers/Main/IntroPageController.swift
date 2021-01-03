//
//  IntroPageController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Displays multiple IntroControllers with different data provided to each one of them.
class IntroPageController: CravyPageController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titles = K.Collections.introSections
        let details = K.Collections.introSectionDetails
        pages = [IntroController(title: titles[0], detail: details[titles[0]]!), IntroController(title: titles[1], detail: details[titles[1]]!), IntroController(title: titles[2], detail: details[titles[2]]!)]
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
        
        dataSource = self
        delegate = self
    }
}
