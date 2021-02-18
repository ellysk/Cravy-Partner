//
//  Cravy_PartnerTests.swift
//  Cravy-PartnerTests
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import XCTest
import FirebaseFunctions
import FirebaseStorage
import FirebaseAuth
import PromiseKit
@testable import Cravy_Partner

class Cravy_PartnerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

//MARK: - Business Data Tests
class BusinessTests: XCTestCase {
    private var businessFB: BusinessFireBase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        businessFB = BusinessFireBase()
    }
    
    func testSigningIn() throws {
        //Given
        let promise = self.expectation(description: "User signed in")
        var rslt: AuthDataResult?
        firstly {
            businessFB.signIn(email: "user1@gmail.com", password: "123456789")
        }.done { (result) in
            //When
            print(result.user.email!)
            print(result.user.uid)
            rslt = result
            promise.fulfill()
        }.catch { (error) in
            if let e = AuthErrorCode(rawValue: error._code) {
                XCTFail(e.description)
            } else {
                XCTFail(error.localizedDescription)
            }
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(rslt)
    }
    
    /// Tests loading all business information
    func testLoadingBusiness() throws {
        //Given
        let promise = self.expectation(description: "business info successfully downloaded")
        var bsn: Business!
        firstly {
            businessFB.loadBusiness()
        }.done { (business) in
            //When
            print(business)
            bsn = business
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(bsn)
    }
    
    func testLoadingBusinessPerformance() throws {
        self.measure {
            do {
                try testLoadingBusiness()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}

//MARK: - Product Data Tests
class ProductTests: XCTestCase {
    private var productFB: ProductFirebase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        productFB = ProductFirebase(state: .active)
    }
        
    func testLoadingProducts() throws {
        //Given
        var prdcts: [Product] = []
        let state: PRODUCT_STATE = .active
        let promise = self.expectation(description: "\(state.description) loaded")
        promise.expectedFulfillmentCount = 2
        
        func load() {
            firstly {
                productFB.loadProducts()
            }.done { (products) in
                //When
                print(products)
                prdcts.append(contentsOf: products)
                promise.fulfill()
            }.catch { (error) in
                XCTFail(error.localizedDescription)
            }
        }
        
        load()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            load()
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertEqual(prdcts.count, 2)
    }
    
    func testLoadingProductMarketStatus() throws {
        //Given
        var stats: [String : Any] = [:]
        let state: PRODUCT_STATE = .active
        let promise = self.expectation(description: "market stats loaded")
        
        firstly {
            try productFB.loadMarketStatus(product: Product(id: "a0yf5CoxyHOG1v5bic4m", date: Date(), image: Data(), imageURL: "", title: "", description: "", tags: [], state: state))
        }.done(on: .main) { (statInfo) in
            //When
            print(statInfo)
            stats = statInfo
            promise.fulfill()
        }.catch(on: .main) { (error) in
            if let e = error as? ProductError {
                XCTFail(e.localizedDescription)
            } else {
                XCTFail(error.localizedDescription)
            }
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertTrue(!stats.isEmpty)
    }
    
    func testUpdatingProductStat() throws {
        //Given
        var newState: PRODUCT_STATE?
        let promise = self.expectation(description: "new product stats saved")
        
        firstly {
            productFB.updateMarketStatus(of: Product(id: "a0yf5CoxyHOG1v5bic4m", date: Date(), image: Data(), imageURL: "", title: "", description: "", tags: [], state: .inActive))
        }.done { (result) in
            //When
            newState = PRODUCT_STATE(rawValue: result.data as! Int)
            print(newState!)
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(newState)
    }
    
    func testSettingPromotion() throws {
        //Given
        let id = "a0yf5CoxyHOG1v5bic4m"
        var isPrmted: Bool = false
        let promise = self.expectation(description: "promotion of product is set")
        
        firstly {
            productFB.setPromotion(id: id, isPromoted: true)
        }.done { (result) in
            //When
            print(result.data)
            guard let isPromoted = result.data as? Bool else {return}
            print(isPromoted)
            isPrmted = isPromoted
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertTrue(isPrmted)
    }
    
    func testUpdatingProduct() throws {
        //Given
        let id = "a0yf5CoxyHOG1v5bic4m"
        let updateData: [String : Any] = [K.Key.title : "Double Cheese Burger"]
        var returnedData: [String : Any] = [:]
        let promise = self.expectation(description: "product has been updated")
        
        firstly {
            productFB.updateProduct(id: id, update: updateData)
        }.done { (results) in
            let (result, _) = results
            guard let data = result.data as? [String : Any] else {return}
            //When
            returnedData = data
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertTrue(!returnedData.isEmpty)
    }
    
    func testSavingImage() throws {
        //Given
        let imageURL = "gs://cravy-food.appspot.com/product_image/B9BE6685-F21B-45A1-8628-9E04EE85C14D.jpeg"
        var data: URL?
        let promise = self.expectation(description: "product image is saved")
        
        firstly {
            try productFB.saveImage(UIImage(named: "pmimage")!)
        }.done { (imageData) in
            //When
            print(imageData?.absoluteString)
            data = imageData
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(data)
    }
    
    func testCreatingProduct() throws {
        //Given
        let productInfo: [String : Any] = [K.Key.title : "Ugali Samaki", K.Key.description : "The best ugali samaki in town", K.Key.tags : ["Ugali", "Sea food", "Samaki", "Swahili"], K.Key.image : UIImage(named: "pmimage")!]
        var prdct: Product?
        let promise = self.expectation(description: "product is created")
        
        firstly {
            try productFB.createProduct(productInfo: productInfo)
        }.done { (result) in
            guard let product = ProductFirebase.toProduct(productInfo: result) else {fatalError("Could not parse product!")}
            //When
            print(product)
            prdct = product
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(prdct)
    }
    
    func testLoadingProductsPerformance() throws {
        self.measure {
            do {
                try testLoadingProducts()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
}
