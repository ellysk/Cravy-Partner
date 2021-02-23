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
import FirebaseFirestore
import PromiseKit

/// Models the necessary information of the user's business.
class Business: CustomStringConvertible, Hashable, Equatable {
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
        var info: [String : Any] = [K.Key.id : id, K.Key.email : email, K.Key.name : name, K.Key.number : phoneNumber, K.Key.recommendations : totalRecommendations, K.Key.subscribers : totalSubscribers]
        if let logo = self.logo, let logoURL = self.logoURL {
            info.updateValue(logo, forKey: K.Key.logo)
            info.updateValue(logoURL, forKey: K.Key.logoURL)
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.id == rhs.id
    }
}

//TODO
/// Structures the required functionality to load business information from the database
class BusinessFireBase: CravyFirebase {
    let db = Firestore.firestore()
    
    override init() {
        super.init()
        let settings = Firestore.firestore().settings
        settings.host = "localhost:8000"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        db.settings = settings
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
    
    func loadBusiness(completion: @escaping (Business?)->()) -> ListenerRegistration {
        let id = Auth.auth().currentUser!.uid
        let email: String = UserDefaults.standard.dictionary(forKey: id)?[K.Key.email] as? String ?? Auth.auth().currentUser!.email!
        let listener = db.collection("businesses").document(id).addSnapshotListener { (docSnapshot, error) in
            if let _ = error {
                completion(nil)
            } else if let businessInfo = docSnapshot?.data() {
                var info = businessInfo
                info.updateValue(id, forKey: K.Key.id)
                info.updateValue(email, forKey: K.Key.email)
                let business = BusinessFireBase.toBusiness(businessInfo: info)
                completion(business)
            }
        }
        return listener
    }
    
    /// Loads all business information except the logo.
    private func loadBusinessInfo() -> Promise<Business> {
        return Promise { (seal) in
            functions.httpsCallable("getBusiness").call { (result, error) in
                if let e = error {
                    seal.reject(e)
                } else if let info = result?.data as? [String : Any], let business = BusinessFireBase.toBusiness(businessInfo: info) {
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
    
    func setBusinessInfo(info: [String : Any]) -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("setBusinessInfo").call(info, completion: seal.resolve)
        }
    }
    
    /// Updates an information on the business with the matching key in the database.
    private func updateBusinessInfo(updateInfo: [String : Any?]) -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("updateBusiness").call(updateInfo, completion: seal.resolve)
        }
    }
    
    /// Updates an information on the business with the matching key in the database.
    /// - Parameters:
    ///   - data: The data to be updated in the database.
    ///   - logoURL: The location of the logo in the database.
    func updateBusiness(update data: [String : Any?], logoURL: String? = nil) -> Promise<(HTTPSCallableResult, Any?)> {
        return Promise { (seal) in
            var businessInfo = data
            businessInfo.removeValue(forKey: K.Key.logo) //Remove the image data so as to make the data parsable.
            if let logo = data[K.Key.logo] as? UIImage {
                if let url = logoURL {
                    //Logo location is present
                    firstly {
                        when(fulfilled: updateBusinessInfo(updateInfo: businessInfo), try saveImage(on: url, image: logo))
                    }.done(seal.fulfill).catch(seal.reject(_:))
                } else {
                    //No Logo present in the database
                    firstly {
                        when(fulfilled: updateBusinessInfo(updateInfo: businessInfo), try saveImage(logo, at: K.Key.businessImagesPath))
                    }.then { (_, imageURL) in
                        self.setBusinessInfo(info: [K.Key.logoURL : imageURL!.absoluteString])
                    }.done { (result) in
                        seal.fulfill((result, nil))
                    }.catch(seal.reject(_:))
                }
            } else {
                //Not updating Business logo
                firstly {
                    updateBusinessInfo(updateInfo: businessInfo)
                }.done { (result) in
                    seal.fulfill((result, nil))
                }.catch(seal.reject(_:))
            }
        }
    }
    
    static func toBusiness(businessInfo: [String : Any]) -> Business? {
        guard let id = businessInfo[K.Key.id] as? String, let email = businessInfo[K.Key.email] as? String, let name = businessInfo[K.Key.name] as? String, let number = businessInfo[K.Key.number] as? String else {return nil}
        let recomm: Int = businessInfo[K.Key.recommendations] as? Int ?? 0
        let subs: Int = businessInfo[K.Key.subscribers] as? Int ?? 0
        let logo = businessInfo[K.Key.logo] as? Data
        let logoURL = businessInfo[K.Key.logoURL] as? String
        let link = businessInfo[K.Key.url] as? String
        
        let business = Business(id: id, email: email, name: name, phoneNumber: number, logoURL: logoURL, logo: logo, totalRecommendations: recomm, totalSubscribers: subs)
        if let link = link {
            let url = URL(string: link)
            business.websiteLink = url
        }
        
        return business
    }
}
