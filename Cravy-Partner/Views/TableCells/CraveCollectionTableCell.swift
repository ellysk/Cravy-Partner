//
//  CraveCollectionTableCell.swift
//  Cravy-Partner
//
//  Created by Cravy on 13/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

protocol CraveCollectionTableCellDelegate {
    func willPresent(popViewController: PopViewController)
}

/// A Table cell that contains a collection view registered to CraveCollectionCell.
class CraveCollectionTableCell: UITableViewCell, UICollectionViewDataSource {
    private var craveCollectionView: CraveCollectionView!
    var craves: [String] = []
    var delegate: CraveCollectionTableCellDelegate?
    var collectionViewDelegate: UICollectionViewDelegate? {
        set {
            craveCollectionView.delegate = newValue
        }
        
        get {
            return craveCollectionView.delegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCraveCollectionTableCell(craves: [String]) {
        self.craves = craves
        setCraveCollectionView()
        self.isTransparent = true
    }
    
    private func setCraveCollectionView() {
        if craveCollectionView == nil {
            craveCollectionView = CraveCollectionView(scrollDirection: .horizontal)
            craveCollectionView.register()
            craveCollectionView.dataSource = self
            craveCollectionView.showsHorizontalScrollIndicator = false
            craveCollectionView.backgroundColor = .clear
            self.addSubview(craveCollectionView)
            craveCollectionView.translatesAutoresizingMaskIntoConstraints = false
            craveCollectionView.VHConstraint(to: self)
            craveCollectionView.heightAnchor(of: UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout.itemSize.height)
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
        cell.addInteractable(.post) { (popVC) in
            self.delegate?.willPresent(popViewController: popVC)
        }
        
        return cell
    }
}
