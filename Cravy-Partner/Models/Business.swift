//
//  Business.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage
import PromiseKit

/// Models the necessary information of the user's business.
class Business: CustomStringConvertible {
    var description: String {
        return "id: \(id)\nemail: \(email)\nname: \(name)\nphonenumber: \(phoneNumber)\nwebsite: \(websiteLink?.absoluteString ?? "Not availabel")\ntotal recommendations: \(totalRecommendations)\nsubscribers: \(totalSubscribers)\nlogo: \(logo != nil ? "I have a logo" : "No logo")"
    }
    
    var id: String
    var email: String
    var name: String
    var phoneNumber: String
    var logoURL: String?
    var logo: Data?
    var websiteLink: URL?
    /// The sum of all the product's recommendations that this business has.
    var totalRecommendations: Int
    /// The number of people who have subscribed to this business.
    var totalSubscribers: Int
    
    init(id: String, email: String, name: String, phoneNumber: String, logoURL: String? = nil, logo: Data?=nil, websiteLink: URL?=nil, totalRecommendations: Int=0, totalSubscribers: Int=0) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.logoURL = logoURL
        self.logo = logo
        self.websiteLink = websiteLink
        self.totalRecommendations = totalRecommendations
        self.totalSubscribers = totalSubscribers
    }
}

//TODO
/// Structures the required functionality to load business information from the database
struct BusinessFireBase {
    private let functions = Functions.functions()
    
    init() {
        functions.useEmulator(withHost: "http://localhost", port: 5001)
    }
    
    func promiseloadBusiness() -> Promise<Business> {
        return firstly {
            promiseLoadBusinessInfo()
        }.then { business in
            self.promiseLoadBusinessLogo(business: business)
        }
    }
    
    private func promiseLoadBusinessInfo() -> Promise<Business> {
        return Promise { (seal) in
            functions.httpsCallable("getBusiness").call { (result, error) in
                if let e = error {
                    seal.reject(e)
                } else if let info = result?.data as? [String : Any] {
                    let id = "eat"
                    let email = "eat@restcafe.co.uk"
                    let name = info[K.Key.name] as! String
                    let number = info[K.Key.number] as! String
                    let link = info[K.Key.url] as? String
                    let recommendations: Int = info[K.Key.recommendations] as? Int ?? 0
                    let subscibers: Int = info[K.Key.subscribers] as? Int ?? 0
                    let logoURL = info[K.Key.logo] as? String
                    
                    let business = Business(id: id, email: email, name: name, phoneNumber: number, logoURL: logoURL, totalRecommendations: recommendations, totalSubscribers: subscibers)
                    if let URLString = link {
                        business.websiteLink = URL(string: URLString)
                    }
                    
                    seal.fulfill((business))
                }
            }
        }
    }
    
    func promiseLoadBusinessLogo(logoURL: String) -> Promise<Data?> {
        return Promise { (seal) in
            Storage.storage().reference(forURL: logoURL).getData(maxSize: 1000*1000*1024, completion: seal.resolve)
        }
    }
    
    private func promiseLoadBusinessLogo(business: Business) -> Promise<Business> {
        return Promise { (seal) in
            if let url = business.logoURL {
                Storage.storage().reference(forURL: url).getData(maxSize: 1000*1000*1024) { (data, error) in
                    if let e = error {
                        seal.reject(e)
                    } else {
                        business.logo = data
                        seal.fulfill(business)
                    }
                }
            } else {
                seal.fulfill(business)
            }
        }
    }
}
