//
//  CravyWebView.swift
//  Cravy-Partner
//
//  Created by Cravy on 02/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import WebKit

/// A WKWebView that handles https requests.
class CravyWebView: WKWebView, WKNavigationDelegate {
    let BASE_URL: String = "https://www.google.com/"
    private var queryURL: String {
        return BASE_URL + "search?q="
    }
    private let session = URLSession.shared
    
    /// Loads up the web content by generating a URL based of the string provided. Handles unsupportedURL error by querying the string using the google search engine.
    /// - Parameters:
    ///   - completionHandler: returns true if content can be loaded up from the internet and a URLError code if recognized.
    func load(_ string: String, taskHandler: @escaping (Bool, URLError.Code?)->()) {
        let urlString = string.replacingOccurrences(of: " ", with: "%20") //Prevent bad url format by replacing spaces with proper string protocol.
        
        //Check if url is available.
        guard let url = URL(string: urlString) else {
            taskHandler(false, nil)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                //Error has occured.
                if let URLError = e as? URLError {
                    if URLError.code == .unsupportedURL {
                        //This error could mean that the user has entered a search query text that produces a bad url format therefore we query using the queryURL.
                        self.query(urlString) { (isCompleted) in
                            taskHandler(isCompleted, nil)
                        }
                    } else if URLError.code == .appTransportSecurityRequiresSecureConnection {
                        //User is trying to access an http web page.
                        self.handleURLError(e) { (code) in
                            taskHandler(false, code)
                        }
                    }
                }
            } else if let data = data, let response = response {
                //Task completed successfully.
                taskHandler(true, nil)
                DispatchQueue.main.async {
                    self.load(data, mimeType: response.mimeType ?? "", characterEncodingName: response.textEncodingName ?? "", baseURL: url)
                }
            } else {
                taskHandler(false, nil)
            }
        }
        task.resume()
    }
    
    private func query(_ string: String, completion: @escaping (Bool)->()) {
        let queryString = "\(queryURL)\(string)"
        if let queryURL = URL(string: queryString) {
            DispatchQueue.main.async {
                self.load(URLRequest(url: queryURL))
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    /// Returns the type of error returned from the URLRequest.
    func handleURLError(_ error: Error, errorHandler: (URLError.Code)->()) {
        if let e = error as? URLError  {
            errorHandler(e.code)
        } else {
            errorHandler(.unknown)
        }
    }
    
//    func clearHistory() {
//        // First we make sure the webview is on the earliest item in the history
//        if self.canGoBack {
//            self.go(to: self.backForwardList.backList.first!)
//        }
//        // Then we navigate to our urlB so that we destroy the old "forward" stack
//        self.load(URLRequest(url: URL(string: BASE_URL)!))
//    }
}
