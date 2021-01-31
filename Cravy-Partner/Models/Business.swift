//
//  Business.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import Foundation

/// Models the necessary information of the user's business.
struct Business {
    var email: String
    var name: String
    var phoneNumber: String
    var logo: Data?
    var websiteLink: URL?
    /// The sum of all the product's recommendations that this business has.
    var totalRecommendations: Int
    /// The number of people who have subscribed to this business.
    var totalSubscribers: Int
    
    init(email: String, name: String, phoneNumber: String, logo: Data?=nil, websiteLink: URL?=nil, totalRecommendations: Int=0, totalSubscribers: Int=0) {
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.logo = logo
        self.websiteLink = websiteLink
        self.totalRecommendations = totalRecommendations
        self.totalSubscribers = totalSubscribers
    }
}
