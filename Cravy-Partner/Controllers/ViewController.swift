//
//  ViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var theLinkView: LinkView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        theLinkView.linkButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        
        let craveImageView = CraveImageView(height: 350, image: UIImage(named: "bgimage"))
        craveImageView.showsLink = true
        craveImageView.linkButton.addTarget(self, action: #selector(action(_:)), for: .touchUpInside)
        craveImageView.cravings = 12
        self.view.addSubview(craveImageView)
        craveImageView.translatesAutoresizingMaskIntoConstraints = false
        craveImageView.topAnchor(to: self.view.safeAreaLayoutGuide)
        craveImageView.HConstraint(to: self.view)
//        craveImageView.centerXAnchor(to: self.view)
//        craveImageView.widthAnchor(of: 180)
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//    }
    
    @objc func action(_ sender: UIButton) {
        print("it works!!")
    }
}
