//
//  Product.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import Foundation

/// Models the necessary product information.
struct Product: Hashable, Equatable {
    var id: String
    var image: Data
    var title: String
    var description: String
    /// The key identifiers of the product. They represent what the product is made up of.
    var tags: Set<String>
    /// The state of the product in relation to the customers and all statistics that go along with it.
    var state: PRODUCT_STATE
    /// The number of people who have recommended one to try this product.
    var recommendations: Int
    /// The number of people who are currently in the mood of consuming the product.
    var cravings: Int
    var productLink: URL?
    
    init(id: String, image: Data, title: String, description: String, tags: Set<String>, state: PRODUCT_STATE, recommendations: Int=0, cravings: Int=0, productLink: URL?=nil) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.tags = tags
        self.state = state
        self.recommendations = recommendations
        self.cravings = cravings
        self.productLink = productLink
    }
    
}

/// Models the necessary information on the interaction of a specific product with the customers.
struct Market {
    var product: Product
    var stats: [String:Int]?
    
    init(product: Product) {
        self.product = product
    }
}
