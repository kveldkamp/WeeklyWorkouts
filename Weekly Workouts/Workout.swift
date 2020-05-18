//
//  Workout.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import Foundation

class Workout{
    var shortDescription: String
    var longDescription: String
    var completed: Bool
    
    init(shortDescription: String, longDescription: String, completed: Bool) {
        self.shortDescription = shortDescription
        self.longDescription = longDescription
        self.completed = completed
    }
    
}
