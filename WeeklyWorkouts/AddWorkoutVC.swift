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
        saveToFireBase(newWorkout: newWorkout)
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveToFireBase(newWorkout: WorkoutCached){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        let shortSummary = newWorkout.shortDescription
        let longSummary = newWorkout.longDescription
        ref = db.collection("workout").addDocument(data: [
            "shortSummary": shortSummary,
            "longSummary": longSummary,
            "completed" : false,
            "dateAdded" : Date().toString()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                newWorkout.firebaseId = ref!.documentID
                CoreDataManager.sharedInstance.createAndSaveWorkout(newWorkout: newWorkout)
                self.dismiss(animated: true, completion: nil)
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
