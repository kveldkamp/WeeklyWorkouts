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
    var resetChecker = WorkoutResetChecker()
    
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
        checkForWorkoutReset()
    }
    
    // checks for weekly reset routine
    func checkForWorkoutReset(){
        if resetChecker.checkForWorkoutReset(now: Date()) == .resetNeeded {
            resetWorkouts()
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
    

    
    
    @objc func workoutDataUpdated(){
        loadWorkouts()
    }
    
    func deleteWorkoutFromCoreData(workout: NSManagedObject){
        CoreDataManager.sharedInstance.context.delete(workout)
    }
    
    func resetWorkouts() {
        for workout in weeklyWorkouts{
            undoWorkout(workout: workout)
        }
    }
    
    func loadWorkouts(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Workout")
        do {
            weeklyWorkouts = try CoreDataManager.sharedInstance.context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func completeWorkout(workout: NSManagedObject){
        workout.setValue(true, forKeyPath: "completed")
        do {
            try CoreDataManager.sharedInstance.context.save()
            //TODO: complete in firebase here if it has an ID
        }
        catch{
            print("unable to complete workout")
        }
    }
    
    func undoWorkout(workout: NSManagedObject){
        workout.setValue(false, forKeyPath: "completed")
        do {
            try CoreDataManager.sharedInstance.context.save()
            //TODO: undo in firebase here if it has an ID
        }
        catch{
            print("unable to undo workout")
        }
    }
    
    func deleteWorkout(workout: Workout, atIndex: Int){
        deleteWorkoutFromCoreData(workout: workout)
        weeklyWorkouts.remove(at: atIndex)
        tableView.reloadData()
    }
    
    func deleteMultipleWorkouts(sharedActivityId: String){
        if let weeklyWorkouts = weeklyWorkouts as? [Workout]{
            for workout in weeklyWorkouts{
                if workout.sharedActivityId == sharedActivityId{
                    deleteWorkoutFromCoreData(workout: workout)
                }
            }
        }
        weeklyWorkouts.removeAll(where:{ $0.value(forKeyPath: "sharedActivityId") as? String == sharedActivityId})
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedWorkout = weeklyWorkouts[indexPath.row] as? Workout{
            
            guard let vc = storyboard?.instantiateViewController(identifier: "WorkoutDetail", creator: { coder in
                return WorkoutDetailVC(coder: coder, activity: selectedWorkout)
            }) else {
                fatalError("Failed to load EditUserViewController from storyboard.")
            }
            vc.activity = selectedWorkout
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workout = weeklyWorkouts[indexPath.row] as! Workout
            if workout.sharedActivityId != nil {
                let alert = UIAlertController(title: "Delete all matching activities?", message: "This activity was created in a group, do you want to delete all matching activities?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete all", style: UIAlertAction.Style.destructive, handler: { action in
                    self.deleteMultipleWorkouts(sharedActivityId: workout.sharedActivityId!)
                }))
                alert.addAction(UIAlertAction(title: "Just delete one", style: UIAlertAction.Style.default, handler: {action in
                    self.deleteWorkout(workout: workout, atIndex: indexPath.row)
                }))
                alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertAction.Style.cancel, handler: nil))
                
                
                self.present(alert, animated: true, completion: nil)
            }
            
            else{
                deleteWorkout(workout: workout, atIndex: indexPath.row)
            }
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

