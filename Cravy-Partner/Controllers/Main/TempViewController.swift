//
//  TempViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let editView = Bundle.main.loadNibNamed("ProductEditView", owner: nil, options: nil)?.first as! UIScrollView
        self.view.addSubview(editView)
        editView.translatesAutoresizingMaskIntoConstraints = false
        editView.VHConstraint(to: self.view)
    }
}
