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
import CoreData

/// Errors thrown associated with the cravy application.
enum CravyError: Error {
    case badStateError
    case imageDataCorruptedError
    case imageSizeError
    case invalidID
    
    var localizedDescription: String {
        switch self {
        case .badStateError:
            return "Market status is not availabel for products with inactive state."
        case .imageDataCorruptedError:
            return "The image could not be processed. Try again later."
        case .imageSizeError:
            return "The image you are trying to upload is too big."
        case .invalidID:
            return "Please try and sign in again."
        }
    }
}

/// Models the necessary product information.
struct Product: Hashable, Equatable {
    var id: String
    /// Date Created
    var date: Date
    var image: Data
    var imageURL: String
    var title: String
    var detail: String
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
        let dateCreatedInfo = [K.Key.seconds : Double(date.timeIntervalSince1970), K.Key.nanoseconds : 0.0]
        var info: [String : Any] = [K.Key.id : id, K.Key.dateCreated : dateCreatedInfo, K.Key.image : image, K.Key.productImageURL : imageURL, K.Key.title : title, K.Key.description : detail, K.Key.tags : tags, K.Key.state : state.rawValue, K.Key.recommendations : recommendations, K.Key.cravings : cravings, K.Key.isPromoted : isPromoted]
        if let link = productLink {
            info.updateValue(link.absoluteString, forKey: K.Key.url)
        }
        return info
    }
    
    init(id: String, date: Date, image: Data, imageURL: String, title: String, description: String, tags: [String], state: PRODUCT_STATE, recommendations: Int=0, cravings: Int=0, productLink: URL?=nil, isPromoted: Bool = false) {
        self.id = id
        self.date = date
        self.image = image
        self.imageURL = imageURL
        self.title = title
        self.detail = description
        self.tags = tags
        self.state = state
        self.recommendations = recommendations
        self.cravings = cravings
        self.productLink = productLink
        self.isPromoted = isPromoted
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    // Caches the product information into core data.
    func cache() throws {
        let context = NSManagedObject.context
        let fetchRequest: NSFetchRequest<ProductModel> = ProductModel.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.id)
        let res = try context.fetch(fetchRequest)
        let cachedProduct: ProductModel = res.isEmpty ? ProductModel(context: context) :  res.first!
       
        cachedProduct.copy(self)
        try context.save()
    }
    
    func delete() throws {
        let context = NSManagedObject.context
        let fetchRequest: NSFetchRequest<ProductModel> = ProductModel.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", self.id)
        let res = try context.fetch(fetchRequest)
        guard let cachedProduct = res.first else {return}
        
        context.delete(cachedProduct)
    }
    
    static func copy(_ productModel: ProductModel) -> Product? {
        guard let id = productModel.id, let date = productModel.date, let image = productModel.image, let imageURL = productModel.imageURL, let title = productModel.title, let detail = productModel.detail, let tags = productModel.tags as? [String], let state = PRODUCT_STATE(rawValue: Int(productModel.state)) else {return nil}
        var product = Product(id: id, date: date, image: image, imageURL: imageURL, title: title, description: detail, tags: tags, state: state, isPromoted: productModel.isPromoted)
        product.productLink = productModel.productLink

        return product
    }
}

/// Structures required functionality to load product information from the database.
class ProductFirebase: CravyFirebase {
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
        super.init()
        self.state = state
    }
    
    override init() {
        super.init()
    }
    
    func createProduct(productInfo: [String : Any]) throws -> Promise<[String : Any]> {
        let image = productInfo[K.Key.image] as! UIImage
        
        func createAfterDownloading(url: URL?) throws -> Promise<[String : Any]> {
            guard let imageURL = url else {throw URLError(.badURL)}
            var info = productInfo
            info.removeValue(forKey: K.Key.image)
            info.updateValue(imageURL.absoluteString, forKey: K.Key.productImageURL)
            return Promise { (seal) in
                functions.httpsCallable("createProduct").call(info) { (result, error) in
                    if let e = error {
                        seal.reject(e)
                    } else if let data = result?.data as? [String : Any], let imageData = image.jpegData(compressionQuality: 1) {
                        var newProductInfo = data
                        newProductInfo.updateValue(imageData, forKey: K.Key.image)
                        seal.fulfill(newProductInfo)
                    }
                }
            }
        }
        
        return firstly {
            try saveImage(image, at: K.Key.productImagesPath)
        }.then { url in
            try createAfterDownloading(url: url)
        }
    }
    
    /// Loads multiple products of the business. The maximum it can load depends on the limit provided.
    func loadProducts(limit: Int = 20, callableFunction: String = "getBusinessProducts") -> Promise<[Product]> {
        var callData = productsCallData
        callData.updateValue(limit, forKey: "limit")
        return Promise { (seal) in
            functions.httpsCallable(callableFunction).call(callData) { (result, error) in
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
                            guard let product = ProductFirebase.toProduct(productInfo: productInfo) else {return}
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
    
    func loadProduct(id: String, productImage: UIImage?) -> Promise<Product> {
        return Promise { (seal) in
            functions.httpsCallable("getProduct").call([K.Key.id : id]) { (result, error) in
                if let e = error {
                    seal.reject(e)
                } else if let productInfo = result?.data as? [String : Any] {
                    var info = productInfo
                    if let image = productImage, let imageData = image.jpegData(compressionQuality: 1) {
                        info.updateValue(imageData, forKey: K.Key.image)
                        guard let product = ProductFirebase.toProduct(productInfo: info) else {return}
                        seal.fulfill(product)
                    } else if let downloadURL = productInfo[K.Key.productImageURL] as? String {
                        firstly {
                            self.loadProductImage(downloadURL: downloadURL)
                        }.done { (imageData) in
                            info.updateValue(imageData, forKey: K.Key.image)
                            guard let product = ProductFirebase.toProduct(productInfo: info) else {return}
                            seal.fulfill(product)
                        }.catch(seal.reject(_:))
                    }
                }
            }
        }
    }
    
    func loadProductImages() -> Promise<[(String, Data)]> {
        return Promise { (seal) in
            firstly {
                loadProductImageURLs()
            }.done { (result) in
                guard let urlData = result.data as? [String : String] else {
                    return seal.fulfill([])
                }
                firstly {
                    when(fulfilled: urlData.map({ (data) -> Promise<(String, Data)> in
                        self.loadProductImage(downloadURL: data.value, productID: data.key)
                    }))
                }.done(seal.fulfill).catch(seal.reject(_:))
            }.catch(seal.reject(_:))
        }
    }
    
    private func loadProductImageURLs() -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("getProductImageURLs").call(completion: seal.resolve)
        }
    }
    
    private func loadProductImage(downloadURL: String) -> Promise<Data> {
        return Promise { (seal) in
            Storage.storage().reference(forURL: downloadURL).getData(maxSize: .MAX_IMAGE_SIZE, completion: seal.resolve)
        }
    }
    
    private func loadProductImage(downloadURL: String, productID: String) -> Promise<(String, Data)> {
        return Promise { (seal) in
            Storage.storage().reference(forURL: downloadURL).getData(maxSize: .MAX_IMAGE_SIZE) { (data, error) in
                if let e = error {
                    seal.reject(e)
                } else if let imageData = data {
                    seal.fulfill((productID, imageData))
                }
            }
        }
    }
    
    /// Loads the relevant market statisitics related to an active product provided.
    /// - Throws: Bad state error, if the provided product is inactive.
    func loadMarketStatus(product: Product) throws -> Promise<[String : Any]> {
        if product.state ==  .inActive {
            throw CravyError.badStateError
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
    
    func deleteProduct(_ product: Product) -> Promise<HTTPSCallableResult> {
        return Promise { (seal) in
            functions.httpsCallable("deleteProduct").call([K.Key.id : product.id], completion: seal.resolve)
        }
    }
    
    static func toProduct(productInfo: [String : Any]) -> Product? {
        guard let id = productInfo[K.Key.id] as? String, let dateCreatedInfo = productInfo[K.Key.dateCreated] as? [String : Double], let image = productInfo[K.Key.image] as? Data, let imageURL = productInfo[K.Key.productImageURL] as? String, let title = productInfo[K.Key.title] as? String, let description = productInfo[K.Key.description] as? String, let tags = productInfo[K.Key.tags] as? [String], let state = PRODUCT_STATE(rawValue: productInfo[K.Key.state] as! Int) else {return nil}
        let recommendations: Int = productInfo[K.Key.recommendations] as? Int ?? 0
        let cravings: Int = productInfo[K.Key.cravings] as? Int ?? 0
        let link = productInfo[K.Key.url] as? String
        let isPromoted: Bool = productInfo[K.Key.isPromoted] as? Bool ?? false
        
        guard let seconds = dateCreatedInfo[K.Key.seconds], let nanoSeconds = dateCreatedInfo[K.Key.nanoseconds] else {return nil}
        let totalSeconds = seconds + (nanoSeconds / 1000000)
        let dateCreated = Date(timeIntervalSince1970: totalSeconds)
        
        var product = Product(id: id, date: dateCreated, image: image, imageURL: imageURL, title: title, description: description, tags: tags, state: state, recommendations: recommendations, cravings: cravings, isPromoted: isPromoted)
        if let link = link, let url = URL(string: link) {
            product.productLink = url
        }
        return product
    }
}
