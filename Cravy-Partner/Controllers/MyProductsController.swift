//
//  MyProductsController.swift
//  Cravy-Partner
//
//  Created by Cravy on 16/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// Handles search and display of the craves of both statuses.
class MyProductsController: UIViewController {
    @IBOutlet weak var searchBar: CravySearchBar!
    @IBOutlet weak var cravyToolBar: CravyToolBar!
    @IBOutlet weak var craveCollectionView: CraveCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        craveCollectionView.register()
        // Do any additional setup after loading the view.
    }
}

