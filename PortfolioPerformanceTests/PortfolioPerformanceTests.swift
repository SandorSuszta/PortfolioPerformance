//
//  PortfolioPerformanceTests.swift
//  PortfolioPerformanceTests
//
//  Created by Nataliia Shusta on 24/01/2023.
//

import XCTest
@testable import PortfolioPerformance

final class PortfolioPerformanceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit_createsObject() {
        XCTAssertNotNil(PPCircularProgressBar())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
