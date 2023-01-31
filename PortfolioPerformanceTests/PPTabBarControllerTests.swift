//
//  PPTabBarControllerTests.swift
//  PortfolioPerformanceTests
//
//  Created by Nataliia Shusta on 26/01/2023.
//
        
import XCTest
@testable import PortfolioPerformance

class PPTabBarControllerTests: XCTestCase {
    
    var sut: PPTabBarController!
    var tabBarItems: [UITabBarItem]?
    
    
    override func setUp() {
        super.setUp()
        sut = PPTabBarController()
        tabBarItems = sut.tabBar.items
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_tabBarItemsCount_shouldReturn2() {
         XCTAssertEqual(tabBarItems?.count, 2)
    }
    
    func test_ViewController_atIndexPath0_shouldBe_MarketVC() {
        let marketNavController = sut.viewControllers?[0] as? UINavigationController
        let watchlistNavController = sut.viewControllers?[1] as? UINavigationController
        
        sut.selectedIndex = 0
        sut.selectedIndex = 1
        
        XCTAssertTrue(marketNavController?.topViewController is MarketViewController)
        XCTAssertTrue(watchlistNavController?.topViewController is WatchlistViewController)
    }
}
