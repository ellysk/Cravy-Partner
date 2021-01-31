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
        let promise = self.expectation(description: "business info loaded")
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
