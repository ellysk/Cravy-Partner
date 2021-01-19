//
//  ProductCollectionViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 03/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import Lottie

enum PRODUCT_STATE {
    case active
    case inActive
}

protocol ScrollViewDelegate {
    func didScroll(scrollView: UIScrollView)
}

protocol PresentationDelegate {
    /// Notifies that a view controller will be presented.
    /// - Parameter viewController: The view controller presented.
    func willPresent(_ viewController: UIViewController?, data: Any?)
}

/// Handles the display of the products that the user has created.
class ProductCollectionViewController: UICollectionViewController {
    private var craves: [String] = []
    private var state: PRODUCT_STATE
    var scrollDelegate: ScrollViewDelegate?
    var presentationDelegate: PresentationDelegate?
    
    init(craves: [String] = [], state: PRODUCT_STATE) {
        self.craves = craves
        self.state = state
        super.init(collectionViewLayout: UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.isTransparent = true
        self.collectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
    }
    
    //MARK:- UICollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        
        cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings", recommendations: 56, tags: ["Chicken", "Wings", "Street", "Spicy", "Fast food"])
        cell.addAction {
            let promo = PromoView(toPromote: "Chicken Wings")
            let popVC = PopViewController(popView: promo, animationView: AnimationView.promoteAnimation) {
                //TODO
            }
            self.presentationDelegate?.willPresent(popVC, data: nil)
            self.present(popVC, animated: true)
        }
        if state == .inActive {
            cell.addInteractable(.post) { (popVC) in
                self.presentationDelegate?.willPresent(popVC, data: nil)
                self.present(popVC, animated: true)
            }
        }
        return cell
    }
    
    //MARK:- UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presentationDelegate?.willPresent(nil, data: "Chicken wings")
    }
    
    //MARK:- UIScrollView Delegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.didScroll(scrollView: scrollView)
    }
}
