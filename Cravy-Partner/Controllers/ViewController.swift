//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var theCollectionView: UICollectionView!
    var layout: UICollectionViewFlowLayout!
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
        
        
        theCollectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: K.Identifier.CollectionViewCell.imageCell)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if layout == nil {
            theCollectionView.setCollectionViewLayout(UICollectionViewFlowLayout.imageCollectionViewFlowLayout, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifier.CollectionViewCell.imageCell, for: indexPath) as! ImageCollectionCell
        cell.setImageCollectionCell(image: images[indexPath.item])
        
        return cell
    }
}
