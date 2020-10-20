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
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class AddWorkoutVC: UIViewController {
    
    @IBOutlet weak var shortDescription: UITextField!
    @IBOutlet weak var longDescription: UITextView!
    
    @IBOutlet weak var saveWorkoutButton: UIButton!
    
    var db: Firestore!
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        longDescription.layer.borderColor = UIColor.lightGray.cgColor
        longDescription.layer.borderWidth = 1
        longDescription.layer.cornerRadius = 5
        longDescription.delegate = self
        shortDescription.layer.borderWidth = 0
        shortDescription.delegate = self
        saveWorkoutButton.layer.cornerRadius = 5
        
        
        //FireStore setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    
    
    
    @IBAction func saveWorkout(_ sender: Any) {
        guard let shortDescription = shortDescription.text, let longDescription = longDescription.text else {return}
        
        let newWorkout = WorkoutCached(shortDescription: shortDescription, longDescription: longDescription , completed: false)
         guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                return
              }
              
            testOutFireBaseStorage()
        
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
                NotificationCenter.default.post(name: NSNotification.Name.CoreData.WorkoutAdded, object: nil)
                self.dismiss(animated: true, completion: nil)
              } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
              }
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func testOutFireBaseStorage(){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("workout").addDocument(data: [
            "shortSummary": "Run",
            "longSummary": "Complete a run over 2 miles",
            "completed" : false
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
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
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
