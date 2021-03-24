//
//  WeeklyWorkoutsTests.swift
//  WeeklyWorkoutsTests
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import XCTest
@testable import WeeklyWorkouts

class WeeklyWorkoutsTests: XCTestCase {
    var tester: ResetChecker!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        tester = ResetChecker()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResetFunctionality() {
        tester.now = Date()
        let result = tester.checkForReset()
        XCTAssertEqual(result, WorkoutResetResult.unchanged)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
