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
    private let BASE_URL: String = "https://www.google.com/"
    private var queryURL: String {
        return BASE_URL + "search?q="
    }
    private let session = URLSession.shared
    
    /// Loads up the web content by generating a URL based of the string provided. Handles unsupportedURL error by querying the string using the google search engine.
    /// - Parameters:
    ///   - completionHandler: returns true if content can be loaded up from the internet.
    func load(_ string: String, completionHandler: @escaping (Bool)->()) {
        let urlString = string.replacingOccurrences(of: " ", with: "+")
        
        guard let url = URL(string: urlString) else {
            completionHandler(false)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                if let URLError = e as? URLError, URLError.code == .unsupportedURL {
                    self.query(urlString) { (isCompleted) in
                        completionHandler(isCompleted)
                    }
                }
            } else if let data = data, let response = response {
                completionHandler(true)
                DispatchQueue.main.async {
                    self.load(data, mimeType: response.mimeType ?? "", characterEncodingName: response.textEncodingName ?? "", baseURL: url)
                }
            } else {
                completionHandler(false)
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
}
