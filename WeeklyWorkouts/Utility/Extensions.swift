//
//  Extensions.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 6/28/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import Foundation


extension Notification.Name{
    enum CoreData{
        static let WorkoutAdded = Notification.Name(rawValue: "WorkoutAdded")
        static let WorkoutsNeedRefreshing = Notification.Name(rawValue: "WorkoutsNeedRefreshing")
    }
}

extension Date{
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func toString() -> String{
        let df = ISO8601DateFormatter()
        let stringDate = df.string(from: self)
        return stringDate
    }
}
