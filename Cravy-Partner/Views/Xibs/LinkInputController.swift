//
//  LinkInputController.swift
//  Cravy-Partner
//
//  Created by Cravy on 26/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

class LinkInputController: NPViewController {
    @IBOutlet weak var searchBar: CravySearchBar!
    @IBOutlet weak var linkLabel: UILabel!
    
    init() {
        super.init(nibName: K.Identifier.NibName.linkInputController, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
extension LinkInputController: CravySearchBarDelegate {
    func didEnquireSearch(_ text: String) {
        let cravyWebVC = CravyWebKitViewController(URLString: text)
        cravyWebVC.delegate = self
        cravyWebVC.modalPresentationStyle = .fullScreen
        cravyWebVC.modalTransitionStyle = .crossDissolve
        
        present(cravyWebVC, animated: true)
    }
    
    func didCancelSearch(_ searchBar: CravySearchBar) {}
    
    func willPresentFilterAlertController(alertController: UIAlertController) {}
}

//MARK:- CravyWebViewController Delegate
extension LinkInputController: CravyWebViewControllerDelegate {
    func didCommitLink(URL: URL) {
        searchBar.clear()
        searchBar.beginResponder = false
        linkLabel.text = URL.absoluteString
        self.productInfoDelegate?.didConfirmProductLink(URL.absoluteString)
    }
}
