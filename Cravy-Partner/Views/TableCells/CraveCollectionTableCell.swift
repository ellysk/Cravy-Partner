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
    var state: PRODUCT_STATE!
    var isLoadingCraves: Bool = true
    private let dummyCount: Int = 3
    private var dataCount: Int {
        if isLoadingCraves {
            return craves.count + dummyCount
        } else {
            return craves.count
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func loadCraves() {
        //CACHE TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.craves = ["one", "two"]
            self.isLoadingCraves = false
            self.craveCollectionView.reloadData()
        }
    }
    
    func setCraveCollectionTableCell(state: PRODUCT_STATE = .inActive) {
        self.isTransparent = true
        self.state = state
        setCraveCollectionView()
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
            loadCraves()
        } else {
            craveCollectionView.reloadData()
        }
    }
    
    //MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        if isLoadingCraves && indexPath.item >= craves.count {
            cell.setCraveCollectionCell(style: .contained)
            cell.startLoadingAnimation()
        } else {
            cell.stopLoadingAnimation()
            cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings", recommendations: 54, tags: ["Chicken", "Wings", "Street food", "Spicy"], style: .contained)
        }
        
        if state == .active {
            //Enable user to promote
            cell.addInteractable(.promote) { (popVC) in
                self.delegate?.willPresent(popViewController: popVC)
            }
        } else if state == .inActive {
            //Enable user to post them
            cell.addInteractable(.post) { (popVC) in
                self.delegate?.willPresent(popViewController: popVC)
            }
        }
        
        return cell
    }
}
