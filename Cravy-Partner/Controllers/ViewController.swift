//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    let theCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.craveCollectionViewFlowLayout)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theCollectionView.backgroundColor = .clear
        theCollectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        
        self.view.addSubview(theCollectionView)
        theCollectionView.translatesAutoresizingMaskIntoConstraints = false
        theCollectionView.VHConstraint(to: self.view)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        
        cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings", recommendations: 56, tags: ["Chicken", "Wings", "Street", "Spicy", "Fast food"])
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.width - 9) / 2, height: 320)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
//    }
}
