//
//  Product.swift
//  Cravy-Partner
//
//  Created by Cravy on 31/01/2021.
//  Copyright © 2021 Cravy. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage
import PromiseKit

/// Errors thrown associated with loading product information.
enum ProductError: Error {
    case badStateError
    case imageDataCorruptedError
    case imageSizeError
    
    var localizedDescription: String {
        switch self {
        case .badStateError:
            return "Market status is not availabel for products with inactive state."
        case .imageDataCorruptedError:
            return "The image could not be processed. Try again later."
        case .imageSizeError:
            return "The image you are trying to upload is too big. Make sure it is not bigger than 5MB."
        }
    }
}

/// Models the necessary product information.
struct Product: Hashable, Equatable {
    var id: String
    var date: Date
    var image: Data
    var imageURL: String
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
    var isPromoted: Bool
    var productInfo: [String : Any] {
        var info: [String : Any] = [K.Key.id : id, K.Key.image : image, K.Key.title : title, K.Key.description : description, K.Key.tags : tags, K.Key.state : state.rawValue, K.Key.recommendations : recommendations, K.Key.cravings : cravings]
        if let link = productLink {
            info.updateValue(link.absoluteString, forKey: K.Key.url)
        }
        return info
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: String, date: Date, image: Data, imageURL: String, title: String, description: String, tags: [String], state: PRODUCT_STATE, recommendations: Int=0, cravings: Int=0, productLink: URL?=nil, isPromoted: Bool = false) {
        self.id = id
        self.date = date
        self.image = image
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.tags = tags
        self.state = state
        self.recommendations = recommendations
        self.cravings = cravings
        self.productLink = productLink
        self.isPromoted = isPromoted
    }
}

/// Structures required functionality to load product information from the database.
class ProductFirebase {
    private let functions = Functions.functions()
    private var state: PRODUCT_STATE = .inActive
    private var lastData: Any?
    /// Data sent to the server to determine which state of products are to be loaded and keep track of the last snapshot of the data loaded.
    var productsCallData: [String : Any] {
        if let data = lastData {
            return [K.Key.state : state.rawValue, "last" : data]
        } else {
            return [K.Key.state : state.rawValue]
        }
    }
    
    init(state: PRODUCT_STATE) {
        self.state = state
        functions.useEmulator(withHost: "http://localhost", port: 5001)
    }
    
    init() {
        functions.useEmulator(withHost: "http://localhost", port: 5001)
    }
    
    /// Loads multiple products of the business. The maximum it can load depends on the limit provided.
    func loadProducts(limit: Int = 20) -> Promise<[Product]> {
        var callData = productsCallData
        callData.updateValue(limit, forKey: "limit")
        return Promise { (seal) in
            functions.httpsCallable("getBusinessProducts").call(callData) { (result, error) in
                if let e = error {
                    seal.reject(e)
                } else if let resultData = result?.data as? [String : Any], let info = resultData["all"] as? [[String : Any]] {
                    self.lastData = resultData["last"] //Get the date created of the last product loaded from the query.
                    var productImagePromises: [Promise<Data>] = []
                    info.forEach { (productInfo) in
                        guard let downloadURL = productInfo[K.Key.productImageURL] as? String else {return}
                        productImagePromises.append(self.loadProductImage(downloadURL: downloadURL))
                    }
                    firstly {
                        when(fulfilled: productImagePromises)
                    }.done { (imageResults) in
                        var products: [Product] = []
                        for (i, data) in imageResults.enumerated() {
                            var productInfo = info[i]
                            productInfo.updateValue(data, forKey: K.Key.image)
                            guard let product = self.toProduct(productInfo: productInfo) else {return}
                            products.append(product)
                        }
                        seal.fulfill(products)
                    }.catch { (error) in
                        seal.reject(error)
                    }
                } else {
                    //Is empty = true
                    seal.fulfill([])
                }
            }
        }
    }
    
    /// Stores the imageon the database in the provided URL.
    /// - Parameters:
    ///   - imageURL: The location of where the image is stored.
    func saveImage(on imageURL: String, image: UIImage) throws -> Promise<Data> {
        return Promise { (seal) in
            let data = try compress(image)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            Storage.storage().reference(forURL: imageURL).putData(data, metadata: metadata) { (metadata, error) in
                if let e = error {
                    seal.reject(e)
                } else {
                    seal.fulfill(data)
                }
            }
        }
    }
    
    //TODO Timeout Error
    private func compress(_ image: UIImage, cq: CGFloat = 1) throws -> Data {
        guard let compressedData = image.jpegData(compressionQuality: cq) else {throw ProductError.imageDataCorruptedError}
        if compressedData.size(in: .byte) > Double(Int64.MAX_IMAGE_SIZE) {
            return try compress(image, cq: cq-0.01)
        } else {
            return compressedData
        }
    }
    
    private func loadProductImage(downloadURL: String) -> Promise<Data> {
        return Promise { (seal) in
            Storage.storage().reference(forURL: downloadURL).getData(maxSize: .MAX_IMAGE_SIZE, completion: seal.resolve)
        }
    }
    
    /// Loads the relevant market statisitics related to an active product provided.
    /// - Throws: Bad state error, if the provided product is inactive.
    func loadMarketStatus(product: Product) throws -> Promise<[String : Any]> {
        if product.state ==  .inActive {
            throw ProductError.badStateError
        } else {
            return Promise { (seal) in
                functions.httpsCallable("getMarketStatus").call([K.Key.id : product.id]) { (result, error) in
                    if let e = error {
                        seal.reject(e)
                    } else if let marketStatInfo = result?.data as? [String : Any] {
                        seal.fulfill(marketStatInfo)
                    }
                }
            }
        }
    }
    
    /// Updates the product state on the market depending on it's current state.
    func updateMarketStatus(of product: Product) -> Promise<HTTPSCallableResult> {
        let newState: PRODUCT_STATE = product.state == .active ? .inActive : .active
        return Promise { (seal) in
            functions.httpsCallable("updateProductState").call([K.Key.id : product.id, K.Key.state : newState.rawValue], completion: seal.resolve)
        }
    }
    
    /// Set the product on the market as promoted or not promoted.
    /// - Parameters:
    ///   - isPromoted: True if you would like the product to be promoted otherwise false.
    func setPromotion(id: String, isPromoted: Bool) -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("setPromotion").call([K.Key.id : id, K.Key.isPromoted : isPromoted], completion: seal.resolve)
        }
    }
    
    func updateProduct(id: String, update data: [String : Any?], imageURL: String? = nil) -> Promise<(HTTPSCallableResult, Data?)> {
        return Promise { (seal) in
            var execute1: Promise<(HTTPSCallableResult, Data)>?
            var execute2: Promise<(HTTPSCallableResult, Data?)>?
            
            var productInfo = data
            productInfo.removeValue(forKey: K.Key.image)
            if let image = data[K.Key.image] as? UIImage, let url = imageURL {
                execute1 = firstly {
                    try when(fulfilled: updateProductInfo(id: id, productInfo: productInfo), saveImage(on: url, image: image))
                }
            } else {
                execute2 = firstly {
                    when(fulfilled: updateProductInfo(id: id, productInfo: productInfo), Promise(resolver: { (seal) in
                        seal.fulfill(nil)
                    }))
                }
            }
            
            if let execute = execute1 {
                execute.done { (results) in
                    seal.fulfill(results)
                }.catch(seal.reject(_:))
            } else if let execute = execute2 {
                execute.done { (results) in
                    seal.fulfill(results)
                }.catch(seal.reject(_:))
            }
        }
    }
    
    private func updateProductInfo(id: String, productInfo: [String : Any?]) -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("updateProduct").call([K.Key.id : id, K.Key.update : productInfo], completion: seal.resolve)
        }
    }
    
    private func toProduct(productInfo: [String : Any]) -> Product? {
        guard let id = productInfo[K.Key.id] as? String, let dateCreatedInfo = productInfo[K.Key.dateCreated] as? [String : Double], let image = productInfo[K.Key.image] as? Data, let imageURL = productInfo[K.Key.productImageURL] as? String, let title = productInfo[K.Key.title] as? String, let description = productInfo[K.Key.description] as? String, let tags = productInfo[K.Key.tags] as? [String], let state = PRODUCT_STATE(rawValue: productInfo[K.Key.state] as! Int) else {return nil}
        let recommendations: Int = productInfo[K.Key.recommendations] as? Int ?? 0
        let cravings: Int = productInfo[K.Key.cravings] as? Int ?? 0
        let link = productInfo[K.Key.url] as? URL
        let isPromoted: Bool = productInfo[K.Key.isPromoted] as? Bool ?? false
        
        guard let seconds = dateCreatedInfo["_seconds"], let nanoSeconds = dateCreatedInfo["_nanoseconds"] else {return nil}
        let totalSeconds = seconds + (nanoSeconds / 1000000)
        let dateCreated = Date(timeIntervalSince1970: totalSeconds)
        
        let product = Product(id: id, date: dateCreated, image: image, imageURL: imageURL, title: title, description: description, tags: tags, state: state, recommendations: recommendations, cravings: cravings, productLink: link, isPromoted: isPromoted)
        return product
    }
}
