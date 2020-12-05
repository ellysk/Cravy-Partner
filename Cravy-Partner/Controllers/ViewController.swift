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
        
//        let contentView = ContentView(contentImage: UIImage(systemName: "magnifyingglass"), contentDescription: "254 search appearances")
//        self.view.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.centerXYAnchor(to: self.view)
//        contentView.widthAnchor(of: 350)
        
        let marketView = MarketView()
        marketView.searchContent = "254 search appearances"
        marketView.viewsContent = "12.2k views"
        marketView.linkContent = "120 visits"
        self.view.addSubview(marketView)
        marketView.translatesAutoresizingMaskIntoConstraints = false
        marketView.centerYAnchor(to: self.view)
        marketView.HConstraint(to: self.view, constant: 16)
    }
}
