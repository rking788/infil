//
//  InfilUITests.swift
//  InfilUITests
//
//  Created by Rob King on 3/22/26.
//

import XCTest

final class InfilUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testMainScreenButtons() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.buttons["Plan Run"].exists)
        XCTAssertTrue(app.buttons["View Planned Runs"].exists)
        
        let navBar = app.navigationBars["Infil"]
        XCTAssertTrue(navBar.buttons["View Planned Runs List"].exists)
        XCTAssertTrue(navBar.buttons["View Profile"].exists)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
