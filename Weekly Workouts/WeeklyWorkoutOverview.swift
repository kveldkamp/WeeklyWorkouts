//
//  WeeklyWorkoutOverview.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import UIKit
import CoreData

class WeeklyWorkoutOverview: UITableViewController {

   
    let workout1 = WorkoutCached(shortDescription: "Hill sprints", longDescription: "do 3 sets", completed: false)
    let workout2 = WorkoutCached(shortDescription: "Bike ride", longDescription: "go for a longer-ish bike ride", completed: false)
    let workout3 = WorkoutCached(shortDescription: "NTC program", longDescription: "part 1 of ntc for the week", completed: false)
    let workout4 = WorkoutCached(shortDescription: "NTC program", longDescription: "part 2 of ntc for the week", completed: false)
    let workout5 = WorkoutCached(shortDescription: "NTC program", longDescription: "part 3 of ntc for the week", completed: false)
    let workout6 = WorkoutCached(shortDescription: "Hip Exercises", longDescription: "follow link in work laptop bookmarks", completed: false)
    let workout7 = WorkoutCached(shortDescription: "Hip Exercises", longDescription: "follow link in work laptop bookmarks", completed: false)
    let workout8 = WorkoutCached(shortDescription: "Hip Exercises", longDescription: "follow link in work laptop bookmarks", completed: false)
    var weeklyWorkoutsCached = [WorkoutCached]()
    var weeklyWorkouts = [NSManagedObject]()
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadWorkouts()
        saveWorkouts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func saveWorkouts(){
        guard weeklyWorkouts.count == 0 else {return}
        weeklyWorkoutsCached.append(workout1)
        weeklyWorkoutsCached.append(workout2)
        weeklyWorkoutsCached.append(workout3)
        weeklyWorkoutsCached.append(workout4)
        weeklyWorkoutsCached.append(workout5)
        weeklyWorkoutsCached.append(workout6)
        weeklyWorkoutsCached.append(workout7)
        weeklyWorkoutsCached.append(workout8)
        
        for workout in weeklyWorkoutsCached{
            saveWorkoutToCoreData(workoutCached: workout)
        }
        
    }
    
    func saveWorkoutToCoreData(workoutCached: WorkoutCached){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        // 1
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
          NSEntityDescription.entity(forEntityName: "Workout", in: managedContext)!
        let workout = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        workout.setValue(workoutCached.shortDescription , forKeyPath: "shortSummary")
        workout.setValue(workoutCached.longDescription, forKeyPath: "longSummary")
        workout.setValue(workoutCached.completed, forKeyPath: "completed")
        
        // 4
        do {
          try managedContext.save()
            weeklyWorkouts.append(workout)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadWorkouts(){
        //1
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: "Workout")
        
        //3
        do {
          weeklyWorkouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func completeWorkout(workout: NSManagedObject){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        workout.setValue(true, forKeyPath: "completed")
        do {
            try managedContext.save()
        }
        catch{
            print("unable to complete workout")
        }
    }
    
    func undoWorkout(workout: NSManagedObject){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        workout.setValue(false, forKeyPath: "completed")
        do {
            try managedContext.save()
        }
        catch{
            print("unable to complete workout")
        }
    }
    
    
    @objc func workoutSwitchChanged(uiSwitch: UISwitch){
        guard uiSwitch.tag < weeklyWorkouts.count else { // safe indexing
            print("index out of bounds on switch error")
            return
        }
        let workout = weeklyWorkouts[uiSwitch.tag]
        
        if uiSwitch.isOn{
            completeWorkout(workout: workout)
        }
        else if !uiSwitch.isOn {
            undoWorkout(workout: workout)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWorkouts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! WorkoutCell
        let workout = weeklyWorkouts[indexPath.row]

        workoutCell.shortDescription.text =  workout.value(forKeyPath: "shortSummary") as? String
        workoutCell.completedSwitch.isOn = workout.value(forKeyPath: "completed") as! Bool
        workoutCell.completedSwitch.tag = indexPath.row
        workoutCell.completedSwitch.addTarget(self, action: #selector(workoutSwitchChanged(uiSwitch:)), for: UIControl.Event.valueChanged)
        return workoutCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }


}

