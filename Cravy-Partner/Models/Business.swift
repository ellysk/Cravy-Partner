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
import FirebaseAuth
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
    /// All information in this struct embedded in a dictionary. useful for integrating with the database.
    var businessInfo: [String : Any] {
        var info: [String : Any] = [K.Key.name : name, K.Key.number : phoneNumber, K.Key.recommendations : totalRecommendations, K.Key.subscribers : totalSubscribers]
        if let logo = self.logo {
            info.updateValue(logo, forKey: K.Key.logo)
        }
        if let link = websiteLink {
            info.updateValue(link.absoluteString, forKey: K.Key.url)
        }
        
        return  info
    }
    
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
    private let auth = Auth.auth()
    
    init() {
        functions.useEmulator(withHost: "http://localhost", port: 5001)
        auth.useEmulator(withHost:"localhost", port: 9099)
    }
    
    /// Sign in the user with email and password.
    func signIn(email: String, password: String) -> Promise<AuthDataResult> {
        return Promise { (seal) in
            auth.signIn(withEmail: email, password: password, completion: seal.resolve)
        }
    }
    
    /// Loads all business information
    /// - Returns: A promise with a resolve of the business struct containing the information loaded from the database,
    func loadBusiness() -> Promise<Business> {
        return firstly {
            loadBusinessInfo()
        }.then { business in
            self.loadBusinessLogo(business: business)
        }
    }
    
    /// Loads all business information except the logo.
    private func loadBusinessInfo() -> Promise<Business> {
        return Promise { (seal) in
            functions.httpsCallable("getBusiness").call { (result, error) in
                if let e = error {
                    seal.reject(e)
                } else if let info = result?.data as? [String : Any] {
                    let id = Auth.auth().currentUser!.uid
                    let email = Auth.auth().currentUser!.email!
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
    
    /// Finds and loads the business logo in the specified url if one exists.
    /// - Parameter logoURL: The location of the image
    /// - Returns: A promise with a resolve of optional data containing all the necesary information to compose an image.
    func loadBusinessLogo(logoURL: String) -> Promise<Data?> {
        return Promise { (seal) in
            Storage.storage().reference(forURL: logoURL).getData(maxSize: .MAX_IMAGE_SIZE, completion: seal.resolve)
        }
    }
    
    private func loadBusinessLogo(business: Business) -> Promise<Business> {
        return Promise { (seal) in
            if let url = business.logoURL {
                Storage.storage().reference(forURL: url).getData(maxSize: .MAX_IMAGE_SIZE) { (data, error) in
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
