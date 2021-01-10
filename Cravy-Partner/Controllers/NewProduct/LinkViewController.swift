//
//  LinkViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 30/12/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import UIKit
import WebKit

/// Handles the input of a website link.
class LinkViewController: UIViewController {
    @IBOutlet weak var searchBar: CravySearchBar!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.setPlaceholder(K.UIConstant.linkSearchPlaceholder, color: K.Color.light.withAlphaComponent(0.5))
        searchBar.isFilterHidden = true
        searchBar.textColor = K.Color.light
        linkLabel.underline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Keyboard delayed to be shown for 0.5 seconds
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
            if self.linkLabel.text == nil || self.linkLabel.text!.removeLeadingAndTrailingSpaces == "" {
                self.searchBar.beginResponder = true
            }
        }
    }
}

//MARK:- CravySearchBar Delegate
extension LinkViewController: CravySearchBarDelegate {
    func didEnquireSearch(_ text: String) {
        self.presentWebWith(URLString: text) { (cravyWebVC) in
            cravyWebVC.delegate = self
        }
    }
    
    func willPresentFilterAlertController(alertController: UIAlertController) {}
}

//MARK:- CravyWebViewController Delegate
extension LinkViewController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        searchBar.clear()
        searchBar.beginResponder = false
        linkLabel.text = URL.absoluteString
        UserDefaults.standard.addURL(URL)
    }
}
