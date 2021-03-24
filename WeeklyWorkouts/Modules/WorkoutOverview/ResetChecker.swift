//
//  ResetChecker.swift
//  WeeklyWorkouts
//
//  Created by Kevin Veldkamp on 2/17/21.
//  Copyright © 2021 Kevin Veldkamp. All rights reserved.
//

import Foundation

class ResetChecker{
    
    var now = Date() //make it a var so can be adjusted for tests
    
    func checkForReset() -> WorkoutResetResult{
        // get week and normalize for sunday
        let thisWeek = getNormalizedWeekOfYear(now: now)
        
        guard let lastWeekUsed = UserDefaults.standard.object(forKey: "weekInt") as? Int else{
            UserDefaults.standard.set(thisWeek, forKey: "weekInt")
            return .uninitialized
        }
        
        if lastWeekUsed != thisWeek{
            UserDefaults.standard.set(thisWeek, forKey: "weekInt")
            return .needsReset
        }
        else{
            return .unchanged
        }
    }
    
        // make sunday part of the previous week, it's the weekend baby
     func getNormalizedWeekOfYear(now: Date) -> Int{
        if now.get(.weekday) == 1{
            if now.get(.weekOfYear) == 1 {
                return 52
            }
            else{
                return now.get(.weekOfYear) - 1
            }
            
        }
        else{
            return now.get(.weekOfYear)
        }
    }
}
