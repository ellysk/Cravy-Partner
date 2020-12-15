//
//  CraveCollectionTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 13/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

/// A Table cell that contains a collection view registered to CraveCollectionCell.
class CraveCollectionTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var craveCollectionView: UICollectionView!
    var craves: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCraveCollectionTableCell(craves: [String]) {
        self.craves = craves
        setCraveCollectionView()
    }
    
    private func setCraveCollectionView() {
        if craveCollectionView == nil {
            self.backgroundColor = .clear
            let layout = UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout
            craveCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            craveCollectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
            craveCollectionView.dataSource = self
            craveCollectionView.delegate = self
            craveCollectionView.showsHorizontalScrollIndicator = false
            craveCollectionView.backgroundColor = .clear
            self.addSubview(craveCollectionView)
            craveCollectionView.translatesAutoresizingMaskIntoConstraints = false
            craveCollectionView.VHConstraint(to: self)
            craveCollectionView.heightAnchor(of: layout.itemSize.height)
        } else {
            craveCollectionView.reloadData()
        }
    }
    
    //MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return craves.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings", recommendations: 54, tags: ["Chicken", "Wings", "Street food", "Spicy"], style: .contained)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected!!")
    }
}
