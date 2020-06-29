//
//  AddWorkoutVC.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 6/28/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddWorkoutVC: UIViewController {
    
    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var longDescription: UITextView!
    
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        longDescription.layer.borderColor = UIColor.lightGray.cgColor
        longDescription.layer.borderWidth = 1
        longDescription.layer.cornerRadius = 5
        longDescription.delegate = self
        shortDescription.layer.borderWidth = 0
        shortDescription.delegate = self
    }
    
    
    
    
    @IBAction func saveWorkout(_ sender: Any) {
        guard let shortDescription = shortDescription.text, let longDescription = longDescription.text else {return}
        
        let newWorkout = WorkoutCached(shortDescription: shortDescription, longDescription: longDescription , completed: false)
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
              workout.setValue(newWorkout.shortDescription , forKeyPath: "shortSummary")
              workout.setValue(newWorkout.longDescription, forKeyPath: "longSummary")
              workout.setValue(newWorkout.completed, forKeyPath: "completed")
              
              // 4
              do {
                try managedContext.save()
                NotificationCenter.default.post(name: NSNotification.Name.CoreData.WorkoutAdded, object: nil, userInfo: nil)
                self.dismiss(animated: true, completion: nil)
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UITextFieldDelegate
extension AddWorkoutVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UITextViewDelegate
extension AddWorkoutVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolder = "Enter a longer description here (optional)"
        if textView.text == placeHolder{
            textView.text = ""
        }
    }
}
