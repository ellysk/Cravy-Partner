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
            try productFB.loadMarketStatus(product: Product(id: "a0yf5CoxyHOG1v5bic4m", date: Date(), image: Data(), title: "", description: "", tags: [], state: state))
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
        var writeResult: HTTPSCallableResult?
        let promise = self.expectation(description: "new product stats saved")
        
        firstly {
            productFB.updateMarketStatus(of: Product(id: "a0yf5CoxyHOG1v5bic4m", date: Date(), image: Data(), title: "", description: "", tags: [], state: .inActive))
        }.done { (result) in
            //When
            print(result.data)
            writeResult = result
            promise.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(writeResult)
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
