//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    let theCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.verticalCraveCollectionViewFlowLayout)
    let images: [UIImage] = [UIImage(named: "promote")!, UIImage(named: "comingsoon")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let lv = LinkView()
//        self.view.addSubview(lv)
//        lv.translatesAutoresizingMaskIntoConstraints = false
//        lv.centerXYAnchor(to: self.view)
        
        
//        let bv = BusinessView(image: UIImage(named: "bgimage"), name: "EAT Restaurant & Cafe", email: "eat@restcafe.co.uk")
//        self.view.addSubview(bv)
//        bv.translatesAutoresizingMaskIntoConstraints = false
//        bv.topAnchor(to: self.view.safeAreaLayoutGuide)
//        bv.HConstraint(to: self.view)
//
//        let bsv = BusinessStatView(recommendations: 100, subscribers: 200)
//        self.view.addSubview(bsv)
//        bsv.translatesAutoresizingMaskIntoConstraints = false
//        bsv.centerYAnchor(to: self.view)
//        bsv.HConstraint(to: self.view, constant: 16)
        
        self.view.addSubview(theCollectionView)
        theCollectionView.backgroundColor = .clear
        theCollectionView.translatesAutoresizingMaskIntoConstraints = false
        theCollectionView.centerYAnchor(to: self.view)
        theCollectionView.HConstraint(to: self.view)
        theCollectionView.heightAnchor(of: 500)
        
        theCollectionView.register(CraveCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.craveCell)
        theCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.craveCell, for: indexPath) as! CraveCollectionCell
        cell.setCraveCollectionCell(image: UIImage(named: "bgimage"), cravings: 100, title: "Chicken wings the big mac innit", recommendations: 56, tags: ["Chicken", "Wings", "Street food", "Spicy"])
        
        return cell
    }
}
