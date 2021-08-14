//
//  FastlaneSnapshotsUITests.swift
//  FastlaneSnapshotsUITests
//
//  Created by Prad Nukala on 8/13/21.
//

import XCTest

class FastlaneSnapshotsUITests: XCTestCase {

    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testTakeSnapshots() {
        snapshot("1-GameView")

        let coordinate = app.tables.otherElements.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))

        for _ in 0...5 {
            coordinate.tap()
        }
        snapshot("2-StepperIncremented")
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        app.textFields.firstMatch.tap()
        app.textFields.buttons["Clear text"].tapElement()
        app.typeText("Taboo")
        snapshot("3-Alert")
        app.buttons["Dismiss"].tap()
        snapshot("4-GameChanged")
    }
}

extension XCUIElement {

    func tapElement() {
        if isHittable {
            tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}
