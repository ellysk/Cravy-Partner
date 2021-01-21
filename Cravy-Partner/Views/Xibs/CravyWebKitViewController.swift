//
//  CravyWebKitViewController.swift
//  Cravy-Partner
//
//  Created by Cravy on 21/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit
import WebKit

protocol CravyWebViewControllerDelegate {
    /// Returns the link of the website the user is currently displaying
    /// - Parameter url: The url of the website displayed.
    func didCommitLink(URL: URL)
}

/// Handles the display of web content
class CravyWebKitViewController: UIViewController {
    @IBOutlet weak var dismissItem: UIBarButtonItem!
    @IBOutlet weak var topItem: UINavigationItem!
    @IBOutlet weak var reloadItem: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var cravyWebView: CravyWebView!
    @IBOutlet weak var linkButton: RoundButton!
    @IBOutlet weak var backItem: UIBarButtonItem!
    @IBOutlet weak var forwardItem: UIBarButtonItem!
    private var navTitle: String? {
        set {
            topItem?.title = newValue
        }
        
        get {
            return topItem?.title
        }
    }
    /// A boolean value that determines if the user is visiting a provided link or trying to add a new link
    var isVisiting: Bool = false
    /// Determines if the web contents will be able to load up.
    private var preLoadFailed: Bool = false
    private var connectionNotSecure: Bool = false
    /// The string required to initiate the webview and load up the web content.
    private var URLString: String?
    var delegate: CravyWebViewControllerDelegate?
    
    init(URLString: String?) {
        super.init(nibName: K.Identifier.NibName.cravyWebKitViewController, bundle: nil)
        self.URLString = URLString
        isVisiting = URLString != nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = cravyWebView.BASE_URL
        addObservers()
        dismissItem.action = #selector(dismissVC)
        dismissItem.image = isModalInPresentation ? UIImage(systemName: "xmark") : UIImage(systemName: "arrow.left")
        linkButton.isHidden = isVisiting
        linkButton.castShadow = !linkButton.isHidden
        cravyWebView.navigationDelegate = self
        load(URLString ?? cravyWebView.BASE_URL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
    
    private func alert(title: String, description: String) {
        let popView = PopView(title: title, detail: description, actionTitle: K.UIConstant.OK)
        let popViewController = PopViewController(popView: popView)
        self.present(popViewController, animated: true)
    }
    
    private func dismissCravyWebKitVC(completion: (()->())? = nil) {
        if self.isModalInPresentation {
            self.dismiss(animated: true, completion: completion)
        } else {
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
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
            self.dismissCravyWebKitVC {
                self.delegate?.didCommitLink(URL: url)
            }
        }
        alertController.addAction(yesAction)
        alertController.addAction(UIAlertAction.cancel)
        
        self.present(alertController, animated: true)
    }
}

//MARK:- Observer
extension CravyWebKitViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //Navigation items update
        if keyPath == "canGoBack" || keyPath == "canGoForward" {
            guard let canNavigate = change?[.newKey] as? Bool else {return}
            
            if keyPath == "canGoBack" {
                backItem.tintColor = canNavigate ? K.Color.primary : K.Color.dark.withAlphaComponent(0.5)
            } else if keyPath == "canGoForward" {
                forwardItem.tintColor = cravyWebView.canGoForward ? K.Color.primary : K.Color.dark.withAlphaComponent(0.5)
            }
            //Progress bar update
        } else if keyPath == "estimatedProgress" {
            guard let progress = change?[NSKeyValueChangeKey.newKey] as? Double else {return}
            progressView.progress = Float(progress)
            progressView.isHidden = progress == 1.0
        }
    }
}

//MARK:- WKNavigationDelegate
extension CravyWebKitViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        navTitle = K.UIConstant.loading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navTitle = webView.title
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
