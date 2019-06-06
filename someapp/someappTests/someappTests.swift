//
//  someappTests.swift
//  someappTests
//
//  Created by User on 03/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import XCTest
@testable import someapp

class someappTests: XCTestCase {
    var sut : ViewControllerBMI!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        sut = ViewControllerBMI()
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let height = 180.0
        let weight = 75.0
        XCTAssertEqual(75.0 / (1.8 * 1.8), sut.bmi(heightF: height, weightF: weight))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
