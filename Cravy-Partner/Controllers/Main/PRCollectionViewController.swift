//
//  PRCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Handles the display of collection of products that require certain actions.
class PRCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var craves: [String] = []
    var state: PRODUCT_STATE = .inActive
    private var isLoadingCraves: Bool = true
    private let dummyCount: Int = 3
    private var dataCount: Int {
        if isLoadingCraves {
            return craves.count + dummyCount
        } else {
            return craves.count
        }
    }
    var delegate: ProductDelegate?
    
    init(state: PRODUCT_STATE) {
        self.state = state
        super.init(collectionViewLayout: UICollectionViewFlowLayout.horizontalCraveCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        self.state = .inActive
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCraves()
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
    
    private func loadCraves() {
        //CACHE TODO
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.craves = ["one", "two"]
            self.isLoadingCraves = false
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        if isLoadingCraves && indexPath.item >= craves.count {
            cell.setCraveCollectionCell(style: .contained)
            cell.startLoadingAnimation()
        } else {
            cell.stopLoadingAnimation()
            cell.setCraveCollectionCell(product: Product(id: "abc", date: Date(), image: UIImage(named: "bgimage")!.pngData()!, imageURL: "image/url", title: "Chicken wings", description: "The best wings in town!", tags: ["Chicken", "Wings", "Street food", "Spicy"], state: .inActive), style: .contained)
        }
        
        if state == .active {
            //Enable user to promote
            cell.addInteractable(.promote) { (popVC) in
                self.startLoader { (loaderVC) in
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        loaderVC.stopLoader {
                            print("promoted!")
                        }
                    }
                }
            }
        } else if state == .inActive {
            //Enable user to post them
            cell.addInteractable(.post) { (popVC) in
                self.startLoader { (loaderVC) in
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        loaderVC.stopLoader {
//                            self.delegate?.didPostProduct(self.craves[indexPath.item], at: indexPath)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.delegate?.didSelectProduct(craves[indexPath.item], at: indexPath)
    }
}
