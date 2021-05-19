//
//  CoreDataManager.swift
//  WeeklyWorkouts
//
//  Created by Kevin Veldkamp on 11/22/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager{
    
    static let sharedInstance = CoreDataManager()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func createAndSaveWorkout(newWorkout: WorkoutCached){
        let entity = NSEntityDescription.entity(forEntityName: "Workout", in: context)!
        let workout = NSManagedObject(entity: entity, insertInto: context)
        
        workout.setValue(newWorkout.shortDescription , forKeyPath: "shortSummary")
        workout.setValue(newWorkout.longDescription, forKeyPath: "longSummary")
        workout.setValue(newWorkout.completed, forKeyPath: "completed")
        if let sharedActivityId = newWorkout.sharedActivityId{
            workout.setValue(sharedActivityId, forKeyPath: "sharedActivityId")
        }
        if let firebaseId = newWorkout.firebaseId{
            workout.setValue(firebaseId, forKeyPath: "firebaseId")
        }
        saveContext()
        
    }
    
    func saveContext(){
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name.CoreData.WorkoutAdded, object: nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
