//
//  Product.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import UIKit

/// Models the necessary product information.
struct Product: Hashable, Equatable {
    var id: String
    var image: Data
    var title: String
    var description: String
    /// The key identifiers of the product. They represent what the product is made up of.
    var tags: [String]
    /// The state of the product in relation to the customers and all statistics that go along with it.
    var state: PRODUCT_STATE
    /// The number of people who have recommended one to try this product.
    var recommendations: Int
    /// The number of people who are currently in the mood of consuming the product.
    var cravings: Int
    var productLink: URL?
    
    init(id: String, image: Data, title: String, description: String, tags: [String], state: PRODUCT_STATE, recommendations: Int=0, cravings: Int=0, productLink: URL?=nil) {
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

/// Structures required functionality to load product information from the database.
struct ProductFirebase {
    /// The maxium number of products to be loaded in one batch.
    var max: Int = 20
    let asyncQueue = DispatchQueue(label: "com.queue.concurrent", qos: .userInitiated, attributes: .concurrent)
    
    /// Loads multiple products. The maximum it can load depends on the limit provided.
    func loadProducts(completion: @escaping ([Product], Error?)->()) {
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.queue.serial")
        var products: [Product] = []
        
        for _ in 0..<max {
            group.enter()
            loadProduct(id: "eat") { (product, error) in
                if let e = error {
                    completion(products,e)
                } else if let prdct = product {
                    addProduct(prdct)
                }
                group.leave()
            }
        }
        
        /// Serially add the product in to the array. This enables to update the array before the group leaving.
        func addProduct(_ product: Product) {
            serialQueue.sync {
                products.append(product)
            }
        }
        
        group.notify(queue: .main) {
            completion(products,nil)
        }
    }
    
    /// Loads all product information availabel.
    func loadProduct(id: String, completion: @escaping (Product?, Error?)->()) {
        var productInfo: [String:Any]?
        var productTags: [String]?
        var productImage: Data?
        
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        loadProductInfo(id: id) { (info, error) in
            if let e = error {
                completion(nil,e)
            } else {
                productInfo = info
            }
            group.leave()
        }
        
        loadProductTags(id: id) { (tags, error) in
            if let e = error {
                completion(nil,e)
            } else {
                productTags = tags
            }
            group.leave()
        }
        
        loadProductImage(imageLocale: "product_images/\(id)") { (data, error) in
            if let e = error {
                completion(nil,e)
            } else {
                productImage = data
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let info = productInfo, let tags = productTags, let image = productImage else {return}
            let title = info[K.Key.title] as! String
            let description = info[K.Key.description] as! String
            let state: PRODUCT_STATE = PRODUCT_STATE(rawValue: info[K.Key.state] as! String)!
            let recommendations: Int = info[K.Key.recommendations] as? Int ?? 0
            let cravings: Int = info[K.Key.cravings] as? Int ?? 0
            let link = info[K.Key.url] as? URL
            
            let product = Product(id: id, image: image, title: title, description: description, tags: tags, state: state, recommendations: recommendations, cravings: cravings, productLink: link)
            completion(product,nil)
        }
    }
    
    /// Loads all product information except the tags and image.
    func loadProductInfo(id: String, completion: @escaping ([String:Any]?, Error?)->()) {
        asyncQueue.asyncAfter(deadline: .now()+0.5) {
            let info: [String:Any] = [K.Key.title:"Chicken wings", K.Key.description:"The best wings in town!", K.Key.state:"active", K.Key.recommendations:1200, K.Key.cravings:1200, K.Key.url:URL(string: "https://dribbble.com/elly_sk/collections/2168834-Profiles")!]
            completion(info,nil)
        }
    }
    
    /// Loads the product's tags.
    func loadProductTags(id: String, completion: @escaping ([String]?, Error?)->()) {
        asyncQueue.asyncAfter(deadline: .now()+0.5) {
            let tags = ["Chicken", "Wings", "Street", "Spicy"]
            completion(tags,nil)
        }
    }
    
    /// Loads the product's image
    func loadProductImage(imageLocale: String, completion: @escaping (Data?, Error?)->()) {
        asyncQueue.asyncAfter(deadline: .now()+1.2) {
            let data = UIImage(named: "bgimage")?.jpegData(compressionQuality: 1.0)
            completion(data,nil)
        }
    }
}
