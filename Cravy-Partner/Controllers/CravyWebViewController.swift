//
//  CravyWebViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import WebKit

protocol CravyWebViewControllerDelegate {
    /// Returns the link of the website the user is currently displaying
    /// - Parameter url: The url of the website displayed.
    func didCommitLink(url: URL)
}

/// Handles the display of the web content.
class CravyWebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var securityItem: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cravyWebView: CravyWebView!
    @IBOutlet weak var linkButton: RoundButton!
    /// The title displayed on the navigation bar
    var webTitle: String? {
        set {
            navigationBar.topItem?.title = newValue
        }
        
        get {
            return navigationBar.topItem?.title
        }
    }
    /// The string required to initiate the webview and load up the web content.
    var URLString: String! = "Hello world"
    private var preLoadFailed: Bool = false
    var delegate: CravyWebViewControllerDelegate?
    
    init(URLString: String) {
        super.init(nibName: nil, bundle: nil)
        self.URLString = URLString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkButton.castShadow = true
        cravyWebView.navigationDelegate = self
        cravyWebView.load(URLString) { (isCompleted) in
            self.preLoadFailed = !isCompleted
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if preLoadFailed {
            let code = URLError.Code.unknown
            self.alert(title: code.title, description: code.description)
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        //TODO
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        cravyWebView.reload()
    }
    
    @IBAction func navigate(_ sender: UIBarButtonItem) {}
    
    @IBAction func linkAction(_ sender: UIButton) {
        guard let url = cravyWebView.url else {return}
        let alertController = UIAlertController(title: "Is this the website you would like to use for linking your product?", message: url.absoluteString, preferredStyle: .actionSheet)
        alertController.pruneNegativeWidthConstraints()
        let yesAction = UIAlertAction(title: "Add link", style: .default) { (action) in
            self.delegate?.didCommitLink(url: url)
        }
        alertController.addAction(yesAction)
        alertController.addAction(UIAlertAction.cancel)
        
        present(alertController, animated: true)
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webTitle = K.UIConstant.loading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webTitle = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        cravyWebView.handleURLError(error) { (code) in
            self.alert(title: code.title, description: code.description)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        cravyWebView.handleURLError(error) { (code) in
            self.alert(title: code.title, description: code.description)
        }
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("redirect")
    }
    
    private func alert(title: String, description: String) {
        //TODO
        let popView = PopView(title: title, detail: description, actionTitle: K.UIConstant.OK)
        popView.isTextFieldHidden = true
        let popViewController = PopViewController(popView: popView)
        self.present(popViewController, animated: true)
    }
}
