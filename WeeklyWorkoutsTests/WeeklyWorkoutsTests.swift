//
//  WeeklyWorkoutsTests.swift
//  Weekly WorkoutsTests
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import XCTest
@testable import WeeklyWorkouts

class WeeklyWorkoutsTests: XCTestCase {
    
    override func setUp() {
        UserDefaults.standard.removeObject(forKey: "weekInt")
    }
    

    func testWorkoutReset() {
        // Since this function relies on multiple app 'launches' and userDefaults, we'll need to simulate multiple 'days' upon launch. These checks also have to be run sequentially in order to get a good test, that's why there's so many Asserts for this one test.
        let resetChecker = WorkoutResetChecker()
        var dateToUse = Date()
        let userCalendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        
        // set to monday in 2021
        dateComponents.year = 2021
        dateComponents.month = 4
        dateComponents.day = 19
        if let newDate = userCalendar.date(from: dateComponents){
            dateToUse = newDate
        }
        XCTAssertEqual(resetChecker.checkForWorkoutReset(now: dateToUse), WorkoutResetCheckResult.unknown)
        
        //increment by less than a week (next sunday)
        dateComponents.year = 2021
        dateComponents.month = 4
        dateComponents.day = 25
        if let newDate = userCalendar.date(from: dateComponents){
            dateToUse = newDate
        }
        XCTAssertEqual(resetChecker.checkForWorkoutReset(now: dateToUse), WorkoutResetCheckResult.upToDate)
        
        //increment to the next day (monday)
        dateComponents.year = 2021
        dateComponents.month = 4
        dateComponents.day = 26
        if let newDate = userCalendar.date(from: dateComponents){
            dateToUse = newDate
        }
        XCTAssertEqual(resetChecker.checkForWorkoutReset(now: dateToUse), WorkoutResetCheckResult.resetNeeded)
        
        //increment to the following monday
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 3
        if let newDate = userCalendar.date(from: dateComponents){
            dateToUse = newDate
        }
        XCTAssertEqual(resetChecker.checkForWorkoutReset(now: dateToUse), WorkoutResetCheckResult.resetNeeded)
        
        //increment by a day again
        dateComponents.year = 2021
        dateComponents.month = 5
        dateComponents.day = 4
        if let newDate = userCalendar.date(from: dateComponents){
            dateToUse = newDate
        }
        XCTAssertEqual(resetChecker.checkForWorkoutReset(now: dateToUse), WorkoutResetCheckResult.upToDate)
         
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
