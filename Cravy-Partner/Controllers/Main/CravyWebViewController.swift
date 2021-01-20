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
    func didCommitLink(URL: URL)
}

/// Handles the display of the web content.
class CravyWebViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var dismissItem: UIBarButtonItem!
    @IBOutlet weak var securityItem: UIBarButtonItem!
    @IBOutlet weak var reloadItem: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cravyWebView: CravyWebView!
    @IBOutlet weak var backLinkButton: UIBarButtonItem!
    @IBOutlet weak var linkButton: RoundButton!
    @IBOutlet weak var forwardLinkButton: UIBarButtonItem!
    /// A boolean value that determines if the user is visiting a provided link or trying to add a new link
    var isVisiting: Bool = false
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
    var URLString: String!
    /// Determines if the web contents will be able to load up.
    private var preLoadFailed: Bool = false
    private var connectionNotSecure: Bool = false
    var delegate: CravyWebViewControllerDelegate?
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isModalInPresentation {
            dismissItem.image = UIImage(systemName: "xmark")
        } else {
            dismissItem.image = UIImage(systemName: "arrow.left")
        }
        reloadItem.isEnabled = false
        linkButton.isHidden = isVisiting
        linkButton.castShadow = !linkButton.isHidden
        cravyWebView.navigationDelegate = self
        addObservers()
        if URLString == nil {
            URLString = self.cravyWebView.BASE_URL
        }
        load(URLString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func load(_ URLString: String) {
        cravyWebView.load(URLString) { (isCompleted, URLErrorCode) in
            self.preLoadFailed = !isCompleted
            self.connectionNotSecure = URLErrorCode != nil && URLErrorCode! == .appTransportSecurityRequiresSecureConnection
        }
    }
    
    private func addObservers() {
        cravyWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        cravyWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        cravyWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
    }
    
    private func removeObservers() {
        cravyWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        cravyWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack))
        cravyWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let code: URLError.Code = connectionNotSecure ? .appTransportSecurityRequiresSecureConnection : .unknown
        if connectionNotSecure {
            self.alert(title: code.title, description: code.description)
        } else if preLoadFailed {
            self.alert(title: code.title, description: code.description)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        connectionNotSecure = false
        preLoadFailed = false
    }
    
    private func dismissCravyWebVC(completion: (()->())? = nil) {
        if self.isModalInPresentation {
            self.dismiss(animated: true, completion: completion)
        } else {
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismissCravyWebVC()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        cravyWebView.reload()
    }
    
    @IBAction func navigate(_ sender: UIBarButtonItem) {
        if sender.tag == -1 {
            //go back
            cravyWebView.goBack()
        } else if sender.tag == 1 {
            //go forward
            cravyWebView.goForward()
        }
    }
    
    @IBAction func linkAction(_ sender: UIButton) {
        guard let url = cravyWebView.url else {return}
        let alertController = UIAlertController(title: K.UIConstant.linkActionTitle, message: url.absoluteString, preferredStyle: .actionSheet)
        alertController.pruneNegativeWidthConstraints()
        let yesAction = UIAlertAction(title: K.UIConstant.addLink, style: .default) { (action) in
            self.dismissCravyWebVC {
                self.delegate?.didCommitLink(URL: url)
//                self.cravyWebView.clearHistory()
            }
        }
        alertController.addAction(yesAction)
        alertController.addAction(UIAlertAction.cancel)
        
        self.present(alertController, animated: true)
    }
    
    private func alert(title: String, description: String) {
        //TODO
        let popView = PopView(title: title, detail: description, actionTitle: K.UIConstant.OK)
        let popViewController = PopViewController(popView: popView)
        self.present(popViewController, animated: true)
    }
    
    //MARK:- Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //Navigation items update
        if keyPath == "canGoBack" || keyPath == "canGoForward" {
            guard let canNavigate = change?[.newKey] as? Bool else {return}
            
            if keyPath == "canGoBack" {
                backLinkButton.tintColor = canNavigate ? K.Color.primary : K.Color.dark.withAlphaComponent(0.5)
            } else if keyPath == "canGoForward" {
                forwardLinkButton.tintColor = cravyWebView.canGoForward ? K.Color.primary : K.Color.dark.withAlphaComponent(0.5)
            }
            //Progress bar update
        } else if keyPath == "estimatedProgress" {
            guard let progress = change?[NSKeyValueChangeKey.newKey] as? Double else {return}
            progressView.progress = Float(progress)
            progressView.isHidden = progress == 1.0
        }
    }
    
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webTitle = K.UIConstant.loading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webTitle = webView.title
        reloadItem.isEnabled = !webView.isLoading
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if !webView.isLoading {
            webView.reload()
        } else {
            cravyWebView.handleURLError(error) { (code) in
                self.alert(title: code.title, description: code.description)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        cravyWebView.handleURLError(error) { (code) in
            self.alert(title: code.title, description: code.description)
        }
    }
}
