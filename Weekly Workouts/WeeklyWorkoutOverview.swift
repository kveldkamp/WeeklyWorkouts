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
    
    var weeklyWorkouts = [NSManagedObject]()
    
    @IBOutlet weak var addWorkoutButton: UIBarButtonItem!
    
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadWorkouts()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(workoutDataUpdated), name: NSNotification.Name.CoreData.WorkoutAdded, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWorkouts()
    }
    
    @objc func workoutDataUpdated(){
        loadWorkouts()
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
    
    func deleteWorkoutFromCoreData(workout: NSManagedObject){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(workout)
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
            tableView.reloadData()
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
            print("unable to undo workout")
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
    
    //MARK: tableView Delegate methods
    
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workout = weeklyWorkouts[indexPath.row]
            deleteWorkoutFromCoreData(workout: workout)
            weeklyWorkouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

