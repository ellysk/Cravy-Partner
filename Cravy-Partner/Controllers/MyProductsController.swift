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
        self.view.setCravyGradientBackground()
        craveCollectionView.register()
        // Do any additional setup after loading the view.
    }
}

//MARK: - UICollectionView DataSource
extension MyProductsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        
        cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings", recommendations: 56, tags: ["Chicken", "Wings", "Street", "Spicy", "Fast food"])
        
        return cell
    }
}

