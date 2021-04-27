//
//  WorkoutResetChecker.swift
//  WeeklyWorkouts
//
//  Created by Kevin Veldkamp on 4/23/21.
//  Copyright © 2021 Kevin Veldkamp. All rights reserved.
//

import Foundation

enum WorkoutResetCheckResult: Int{
    case unknown = 0
    case upToDate = 1
    case resetNeeded = 2
}

class WorkoutResetChecker{
    
    func checkForWorkoutReset(now: Date) -> WorkoutResetCheckResult {
        var thisWeek: Int
        
        // get week and normalize for sunday
        thisWeek = getNormalizedWeekOfYear(now: now)
        
        guard let lastWeekUsed = UserDefaults.standard.object(forKey: "weekInt") as? Int else{
            UserDefaults.standard.set(thisWeek, forKey: "weekInt")
            return .unknown
        }
        
        if lastWeekUsed != thisWeek{
            UserDefaults.standard.set(thisWeek, forKey: "weekInt")
            return .resetNeeded
        }
        
        return .upToDate
    }
    
    
    // make sunday part of the previous week, it's the weekend baby
    private func getNormalizedWeekOfYear(now: Date) -> Int{
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
