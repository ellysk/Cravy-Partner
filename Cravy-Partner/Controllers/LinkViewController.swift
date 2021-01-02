//
//  LinkViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import WebKit

class LinkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showsCravySearchBar = true
        self.cravySearchBar!.setPlaceholder("Enter a link or search", color: K.Color.light.withAlphaComponent(0.5))
        self.cravySearchBar!.isFilterHidden = true
    }
}
