//
//  Business.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Models the necessary information of the user's business.
struct Business {
    var id: String
    var email: String
    var name: String
    var phoneNumber: String
    var logo: Data?
    var websiteLink: URL?
    /// The sum of all the product's recommendations that this business has.
    var totalRecommendations: Int
    /// The number of people who have subscribed to this business.
    var totalSubscribers: Int
    
    init(id: String, email: String, name: String, phoneNumber: String, logo: Data?=nil, websiteLink: URL?=nil, totalRecommendations: Int=0, totalSubscribers: Int=0) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.logo = logo
        self.websiteLink = websiteLink
        self.totalRecommendations = totalRecommendations
        self.totalSubscribers = totalSubscribers
    }
}

//TODO
/// Structures the required functionality to load business information from the database
struct BusinessFireBase {
    private let group = DispatchGroup()
    let asyncQueue = DispatchQueue(label: "com.queue.concurrent", qos: .userInitiated, attributes: .concurrent)
    
    /// Loads all the business information availabel.
    func loadBusiness(completion: @escaping (Business?)->()) {
        var business: Business!
        var logoData: Data?
        
        group.enter()
        group.enter()
        
        loadBusinessInfo { (loadedBusiness) in
            if let bsn = loadedBusiness {
                business = bsn
            } else {
                completion(nil)
            }
            self.group.leave()
        }
        loadBusinessLogo { (data, error) in
            if error != nil {
                completion(nil)
            } else {
                logoData = data
            }
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            business.logo = logoData
            completion(business)
        }
    }
    
    /// Loads all the business information except the logo image.
    func loadBusinessInfo(completion: @escaping (Business?)->()) {
        asyncQueue.asyncAfter(deadline: .now()+1) {
            let info: [String:Any] = [K.Key.name:"EAT Restaurant & Cafe", K.Key.number:"07948226722", K.Key.url:URL(string:"https://medium.com/@ekoka56")!, K.Key.recommendations:60800, K.Key.subscribers:1300]
            
            let id = "eat"
            let email = "eat@restcafe.co.uk"
            let name = info[K.Key.name] as! String
            let number = info[K.Key.number] as! String
            let link = info[K.Key.url] as? URL
            let recommendations: Int = info[K.Key.recommendations] as? Int ?? 0
            let subscibers: Int = info[K.Key.subscribers] as? Int ?? 0
            
            let business = Business(id: id, email: email, name: name, phoneNumber: number, websiteLink: link, totalRecommendations: recommendations, totalSubscribers: subscibers)
            completion(business)
        }
    }
    
    /// Loads the business logo image data.
    func loadBusinessLogo(completion: @escaping (Data?, Error?)->()) {
        asyncQueue.asyncAfter(deadline: .now()+2.5) {
            let data = UIImage(named: "bgimage")?.jpegData(compressionQuality: 1.0)
            completion(data,nil)
        }
    }
}
