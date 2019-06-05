//
//  ViewControllerBMI.swift
//  someapp
//
//  Created by Maksim Dvoryakov on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewControllerBMI: UIViewController {
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bmi(heightF: Double, weightF: Double)->Double{
        var I = weightF/(heightF*heightF)*10000
        return I
    }
    
    func info(I: Double){
        if(I<=16){
           infoLabel.text = "Severly underweight"
        }
        else if(I<=18.5){
            infoLabel.text = "Underweight"
        }
        else if(I<=24.99){
            infoLabel.text = "Normal"
        }
        else if(I<=30){
            infoLabel.text = "Overweight"
        }
        else if(I<=35){
            infoLabel.text = "Obesity"
        }
        else if(I<=40){
            infoLabel.text = "Severly obesity"
        }
        else{
            infoLabel.text = "Very severly obesity"
        }
    }
    
    @IBAction func calculateBMI(_ sender: Any) {
        if height.text=="" || weight.text==""{
            let alertController = UIAlertController(title: "Warning", message: "You did not fill all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { _ in }))
            return
        }
        let heightD: Double! = Double(height.text!)
        let weightD: Double! = Double(weight.text!)
        var I = bmi(heightF: heightD, weightF: weightD)
        bmiLabel.text = "BMI = " + (NSString(format: "%.2f", I) as String)
        info(I: I)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
