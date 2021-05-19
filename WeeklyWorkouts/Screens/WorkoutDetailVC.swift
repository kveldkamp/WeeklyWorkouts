//
//  WorkoutDetailVC.swift
//  Weekly Workouts
//
//  Created by Kevin Veldkamp on 7/6/20.
//  Copyright © 2020 Kevin Veldkamp. All rights reserved.
//

import Foundation
import UIKit

class WorkoutDetailVC : UIViewController{
    
    
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var longDescription: UITextView!
    
    var activity: Workout
    
    init?(coder: NSCoder, activity: Workout) {
        self.activity = activity
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an activity.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescription.text = activity.shortSummary
        longDescription.text = activity.longSummary
        longDescription.isEditable = false
        showEditButton()
    }
    
    func showEditButton(){
        let editButton = UIBarButtonItem(title: "Edit" , style: .plain, target: self, action: #selector(editButtonPressed))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    func showSaveButton(){
        let saveButton = UIBarButtonItem(title: "Save" , style: UIBarButtonItem.Style.done, target: self, action: #selector(saveButtonPressed))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func editButtonPressed(){
        longDescription.isEditable = true
        longDescription.becomeFirstResponder()
        showSaveButton()
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func saveButtonPressed(){
        longDescription.isEditable = false
        longDescription.resignFirstResponder()
        showEditButton()
        self.navigationItem.hidesBackButton = false
        
        if activity.sharedActivityId != ""{
            let alert = UIAlertController(title: "Update all matching activities?", message: "This activity was created in a group, do you want to update all matching activities?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Update all", style: UIAlertAction.Style.destructive, handler: { action in
                // update a bunch somehow
            }))
            alert.addAction(UIAlertAction(title: "Just Update one", style: UIAlertAction.Style.default, handler: {action in
                self.saveToCoreData()
                //send to firebase
            }))
            alert.addAction(UIAlertAction(title: "Nevermind", style: UIAlertAction.Style.cancel, handler: nil))
            
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
            saveToCoreData()
            //send to firebase
        }
    }
    
    func saveToCoreData(){
        activity.longSummary = longDescription.text
        CoreDataManager.sharedInstance.saveContext()
    }
    
}
