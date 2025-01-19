//
//  A103_SwiftUI_Apple_Photos_App_Transition_iOS_17UITestsLaunchTests.swift
//  A103.SwiftUI Apple Photos App Transition-iOS 17UITests
//
//  Created by main on 2025/1/19.
//

import XCTest

final class A103_SwiftUI_Apple_Photos_App_Transition_iOS_17UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
