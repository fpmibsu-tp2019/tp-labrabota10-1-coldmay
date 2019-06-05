//
//  AddRunViewController.swift
//  someapp
//
//  Created by User on 04/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreData

class AddRunViewController: UIViewController {

    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addRun(_ sender: Any) {
        let duration = Int32(durationTextField.text!)!
        let distance = Double(distanceTextField.text!)!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newRun : Run = NSEntityDescription.insertNewObject(forEntityName: "Run", into: context) as! Run
        newRun.duration = duration
        newRun.distance = distance
        newRun.calories = Int32(distance * 60) // whatever, if you know the correct formula write it here
        newRun.speed = distance / (Double(duration) / 60)
        newRun.date = datePicker.date as NSDate
        
        do {
            try context.save()
        } catch {
            print("Saving failed")
        }
        
        performSegue(withIdentifier: "toHistory", sender: sender)
    }
    
}
