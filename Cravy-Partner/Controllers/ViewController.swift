//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cravyToolBar = CravyToolBar(titles: ["Active", "Inactive"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cravyToolBar)
        cravyToolBar.translatesAutoresizingMaskIntoConstraints = false
        cravyToolBar.topAnchor(to: self.view.safeAreaLayoutGuide)
        cravyToolBar.heightAnchor(of: K.Size.CRAVY_TOOL_BAR_HEIGHT)
        cravyToolBar.widthAnchor(to: self.view)
        // Do any additional setup after loading the view.
    }
}
