//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let lv = LinkView()
//        self.view.addSubview(lv)
//        lv.translatesAutoresizingMaskIntoConstraints = false
//        lv.centerXYAnchor(to: self.view)
        
        
        let bv = BusinessView(image: UIImage(named: "bgimage"), name: "EAT Restaurant & Cafe", email: "eat@restcafe.co.uk")
        self.view.addSubview(bv)
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.topAnchor(to: self.view.safeAreaLayoutGuide)
        bv.HConstraint(to: self.view)
        
        let bsv = BusinessStatView(recommendations: 100, subscribers: 200)
        self.view.addSubview(bsv)
        bsv.translatesAutoresizingMaskIntoConstraints = false
        bsv.centerYAnchor(to: self.view)
        bsv.HConstraint(to: self.view, constant: 16)
    }
}
