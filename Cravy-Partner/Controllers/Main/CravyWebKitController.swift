//
//  CrayWebKitController.swift
//  Cravy-Partner
//
//  Created by Cravy on 20/01/2021.
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
class CravyWebKitController: UIViewController {
    private var navigationBar = UINavigationBar()
    private var progressView = UIProgressView(progressViewStyle: .default)
    private var cravyWebView =  CravyWebView()
    private var toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
    private var backItem: UIBarButtonItem!
    private var forwardItem: UIBarButtonItem!
    private var tintColor: UIColor = K.Color.secondary
    private var navTitle: String? {
        set {
            navigationBar.topItem?.title = newValue
        }
        
        get {
            return navigationBar.topItem?.title
        }
    }
    var reloadItem: UIBarButtonItem {
        return (navigationBar.topItem?.rightBarButtonItem)!
    }
    private var linkButton = RoundButton()
    /// A boolean value that determines if the user is visiting a provided link or trying to add a new link
    var isVisiting: Bool = false
    /// Determines if the web contents will be able to load up.
    private var preLoadFailed: Bool = false
    private var connectionNotSecure: Bool = false
    /// The string required to initiate the webview and load up the web content.
    private var URLString: String?
    var delegate: CravyWebViewControllerDelegate?
    
    init(URLString: String?) {
        super.init(nibName: nil, bundle: nil)
        self.URLString = URLString
        isVisiting = URLString != nil
        setCravyWebKitLayout()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCravyWebKitLayout() {
        setNavigationBar()
        setProgressBar()
        setToolBar()
        setCravyWebView()
    }
    
    deinit {
        removeObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = tintColor
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
    
    private func setNavigationBar() {
        //set top navigation item
        navigationBar.items = [UINavigationItem(title: URLString ?? cravyWebView.BASE_URL)]
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = tintColor
        navigationBar.titleTextAttributes = [.foregroundColor : K.Color.dark]
        self.view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor(to: self.view.safeAreaLayoutGuide)
        navigationBar.HConstraint(to: self.view)
        
        //Add items on the navigation bar
        
        //left bar items
        var dismissItem: UIBarButtonItem!
        if isModalInPresentation {
            dismissItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(dismissVC))
        } else {
            dismissItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(dismissVC))
        }
        dismissItem.tintColor = K.Color.primary
        let securityItem = UIBarButtonItem(image: UIImage(systemName: "lock.fill"), style: .plain, target: nil, action: nil)
        securityItem.tintColor = K.Color.positive
        navigationBar.topItem?.leftBarButtonItems = [dismissItem, securityItem]
        
        //Right bar item
        let reloadItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: cravyWebView, action: #selector(cravyWebView.reload))
        reloadItem.tintColor = K.Color.primary
        reloadItem.isEnabled = false
        navigationBar.topItem?.rightBarButtonItem = reloadItem
    }
    
    private func setProgressBar() {
        progressView.progress = 0.5
        progressView.progressTintColor = K.Color.primary
        progressView.trackTintColor = tintColor
        self.view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        progressView.HConstraint(to: self.view)
    }
    
    private func setCravyWebView() {
        self.view.addSubview(cravyWebView)
        cravyWebView.translatesAutoresizingMaskIntoConstraints = false
        cravyWebView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        cravyWebView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        cravyWebView.HConstraint(to: self.view)
        self.view.sendSubviewToBack(cravyWebView)
    }
    
    private func setToolBar() {
        //Add items in tool bar
        //Navigates the view to previous web content
        toolBar.barTintColor = K.Color.secondary
        backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(navigate(_:)))
        backItem.tag = -1
        backItem.tintColor = K.Color.dark.withAlphaComponent(0.5)
        //Navigates the view to next web content
        forwardItem = UIBarButtonItem(image: UIImage(systemName:"chevron.right"), style: .done, target: self, action: #selector(navigate(_:)))
        forwardItem.tag = 1
        forwardItem.tintColor = K.Color.dark.withAlphaComponent(0.5)
        let widthToFill = UIScreen.main.bounds.width / 8
        toolBar.setItems([UIBarButtonItem.fixedSpace(widthToFill), backItem, UIBarButtonItem.flexibleSpace, forwardItem, UIBarButtonItem.fixedSpace(widthToFill)], animated: false)
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.bottomAnchor(to: self.view.safeAreaLayoutGuide)
        toolBar.HConstraint(to: self.view)
        
        setLinkButton()
    }
    
    private func setLinkButton() {
        linkButton.addTarget(self, action: #selector(linkAction(_:)), for: .touchUpInside)
        linkButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        linkButton.tintColor = K.Color.primary
        self.view.insertSubview(linkButton, aboveSubview: toolBar)
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.bottomAnchor(to: self.view.safeAreaLayoutGuide)
        linkButton.centerXAnchor(to: self.view)
        linkButton.sizeAnchorOf(width: 60, height: 60)
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
    
    @objc func navigate(_ sender: UIBarButtonItem) {
        if sender.tag == -1 {
            //go back
            cravyWebView.goBack()
        } else if sender.tag == 1 {
            //go forward
            cravyWebView.goForward()
        }
    }
    
    @objc func linkAction(_ sender: UIButton) {
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
extension CravyWebKitController {
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
extension CravyWebKitController: WKNavigationDelegate {
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
