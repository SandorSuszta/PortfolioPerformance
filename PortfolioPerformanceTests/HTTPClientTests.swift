import XCTest
@testable import PortfolioPerformance

class HTTPCientTests: XCTestCase {
    
    var sut: HTTPClient!
    
    override func setUp() {
        super.setUp()
        sut = HTTPClient(parser: JSONParser())
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
}

