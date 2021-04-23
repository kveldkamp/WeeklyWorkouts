//
//  WeeklyWorkoutsTests.swift
//  Weekly WorkoutsTests
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import XCTest
class WeeklyWorkoutsTests: XCTestCase {
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //TODO: make this data into a unit test for resetChecker
        /*var dateComponents = DateComponents()
        dateComponents.year = 2022
        dateComponents.month = 1
        dateComponents.day = 3
        dateComponents.timeZone = TimeZone(abbreviation: "PST") // Japan Standard Time
        dateComponents.hour = 8
        dateComponents.minute = 34
        // Create date from components
        let userCalendar = Calendar(identifier: .gregorian) // since the components above (like year 1980) are for Gregorian
        let fakeDate = userCalendar.date(from: dateComponents)
        if let fakeDate = fakeDate{
            now = fakeDate
        }
         */
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
