//
//  Cravy_PartnerTests.swift
//  Cravy-PartnerTests
//
//  Created by Cravy on 29/11/2020.
//  Copyright © 2020 Cravy. All rights reserved.
//

import XCTest
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
    
    /// Tests loading all business information
    func testLoadingBusiness() throws {
        //Given
        let promise = self.expectation(description: "business loaded")
        var bsn: Business?
        businessFB.loadBusiness { (business) in
            //When
            bsn = business
            promise.fulfill()
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(bsn, bsn.debugDescription)
    }
}

//MARK: - Product Data Tests
class ProductTests: XCTestCase {
    private var productFB: ProductFirebase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        productFB = ProductFirebase()
    }
    
    func testLoadingProduct() throws {
        //Given
        let promise = self.expectation(description: "product loaded")
        var prdct: Product?
        productFB.loadProduct(id: "eat") { (product, error) in
            //When
            if let e = error {
                XCTFail(e.localizedDescription)
            } else {
                prdct = product
                promise.fulfill()
            }
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertNotNil(prdct)
    }
    
    func testLoadingMultipleProducts() throws {
        //Given
        let promise = self.expectation(description: "products loaded")
        var prdcts: [Product] = []
        productFB.loadProducts { (products, error) in
            //When
            if let e = error {
                XCTFail(e.localizedDescription)
            } else {
                prdcts = products
                promise.fulfill()
            }
        }
        //Then
        self.wait(for: [promise], timeout: 5)
        XCTAssertEqual(prdcts.count, 20)
    }
    
    func testProductLoadPerformance() throws {
        self.measure {
            let promise = self.expectation(description: "product loaded")
            productFB.loadProduct(id: "eat") { (product, error) in
                promise.fulfill()
            }
            self.wait(for: [promise], timeout: 5)
        }
    }
    
    func testMultipleProductLoadPerformance() throws {
        self.measure {
            let promise = self.expectation(description: "products loaded")
            productFB.loadProducts { (products, error) in
                promise.fulfill()
            }
            self.wait(for: [promise], timeout: 5)
        }
    }
}
