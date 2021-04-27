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
    
    var shortText = ""
    var longText = ""
    var sharedActivityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescription.text = shortText
        longDescription.text = longText
        longDescription.isEditable = false
        let editButton = UIBarButtonItem(title: "Edit" , style: .plain, target: self, action: #selector(editButtonPressed))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonPressed(){
        longDescription.isEditable = true
        longDescription.becomeFirstResponder()
        self.navigationItem.hidesBackButton = true
    }
    
}
