//
//  LinkViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import WebKit

/// Handles the input of a website link.
class LinkViewController: UIViewController {
    @IBOutlet weak var searchBar: CravySearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.setPlaceholder(K.UIConstant.linkSearchPlaceholder, color: K.Color.light.withAlphaComponent(0.5))
        searchBar.isFilterHidden = true
    }
}
