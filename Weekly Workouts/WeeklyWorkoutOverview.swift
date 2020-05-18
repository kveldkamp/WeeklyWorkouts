//
//  WeeklyWorkoutOverview.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 5/17/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import UIKit

class WeeklyWorkoutOverview: UITableViewController {

    let workout1 = Workout(shortDescription: "HIIT type workout", longDescription: "Something to get the blood flowing either upper body or lower body, but not strictly lifting weights or cardio, some hybrid", completed: false)
    let workout2 = Workout(shortDescription: "Hill sprints", longDescription: "do 3 sets", completed: false)
    let workout3 = Workout(shortDescription: "Bike ride", longDescription: "go for a longer-ish bike ride", completed: false)
    let workout4 = Workout(shortDescription: "HIIT type workout", longDescription: "Something to get the blood flowing either upper body or lower body, but not strictly lifting weights or cardio, some hybrid", completed: false)
    var weeklyWorkouts = [Workout]()
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        attachWorkouts()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func attachWorkouts(){
        weeklyWorkouts.append(workout1)
        weeklyWorkouts.append(workout2)
        weeklyWorkouts.append(workout3)
        weeklyWorkouts.append(workout4)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWorkouts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! WorkoutCell
        workoutCell.shortDescription.text = weeklyWorkouts[indexPath.row].shortDescription
        workoutCell.completedSwitch.isOn = weeklyWorkouts[indexPath.row].completed
        return workoutCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }


}

