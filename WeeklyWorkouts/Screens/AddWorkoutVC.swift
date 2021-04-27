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
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveWorkoutButton: UIButton!
    
    var pickerData = [String]()
    var db: Firestore!
    
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.isHidden = false
        buildUI()
        linkUpKeyboardDismissal()
        setupTextFields()
        //FireStore setup
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    
    func buildUI(){
        longDescription.layer.borderColor = UIColor.lightGray.cgColor
        longDescription.layer.borderWidth = 1
        longDescription.layer.cornerRadius = 5
        longDescription.delegate = self
        shortDescription.layer.borderWidth = 0
        shortDescription.delegate = self
        saveWorkoutButton.layer.cornerRadius = 5
        populatePickerView()
    }
    
    func populatePickerView(){
        pickerData = ["1x a week", "2x a week", "3x a week", "4x a week", "5x a week", "6x a week", "7x a week"]
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    
    func setupTextFields() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        longDescription.inputAccessoryView = toolbar

    }
    
    @objc func doneButtonTapped() {
        view.endEditing(true)
    }
    
    func linkUpKeyboardDismissal(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
    func workoutInputIsInvalid() -> Bool{
        if shortDescription.text == ""{
            return true
        }
        return false
    }
    
    func cleanOptionalDescription(textToClean: String) -> String{
        if textToClean == "Enter a longer description here (optional)"{
            return ""
        }
        return textToClean
    }
    
    @IBAction func saveWorkout(_ sender: Any) {
        if workoutInputIsInvalid(){
            showDefaultError(message: "Enter a workout name")
            return
        }
        guard let shortDescription = shortDescription.text, var longDescription = longDescription.text else {return}
        
        longDescription = cleanOptionalDescription(textToClean: longDescription)

        let newWorkout = WorkoutCached(shortDescription: shortDescription, longDescription: longDescription , completed: false)
        let timesPerWeek = (pickerView.selectedRow(inComponent: 0) + 1) //account for zero indexing
        
        if timesPerWeek > 1{
            newWorkout.sharedActivityId = String((Date().timeIntervalSince1970).rounded())
        }
        for _ in 1...timesPerWeek{
            saveToFireBase(newWorkout: newWorkout)
        }
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showDefaultError(message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveToFireBase(newWorkout: WorkoutCached){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        let dataDictionary = buildFireBasePayload(newWorkout: newWorkout)
        ref = db.collection("workout").addDocument(data: dataDictionary) { err in
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
    
    func buildFireBasePayload(newWorkout: WorkoutCached) -> [String: Any]{
        var dictionary = ["shortSummary": newWorkout.shortDescription,
                          "longSummary": newWorkout.longDescription,
                          "completed" : false,
                          "dateAdded" : Date().toString()] as [String : Any]
        
        if let sharedActivityId = newWorkout.sharedActivityId{
            dictionary["sharedActivityId"] = sharedActivityId
        }
        return dictionary
    }
    
}

//MARK: - UITextFieldDelegate
extension AddWorkoutVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UITextViewDelegate
extension AddWorkoutVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolder = "Enter a longer description here (optional)"
        if textView.text == placeHolder{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}


//MARK: - UIPickerView Delegate and DataSource
extension AddWorkoutVC: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}

extension AddWorkoutVC: UIPickerViewDelegate{
    
}
