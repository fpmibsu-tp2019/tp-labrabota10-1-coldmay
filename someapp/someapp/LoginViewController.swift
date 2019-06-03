//
//  LoginViewController.swift
//  someapp
//
//  Created by User on 03/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UserDefaults.standard.set("login", forKey: "login")
        UserDefaults.standard.set("1111", forKey: "password")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signIn(_ sender: Any) {
        let login = loginTextField!.text
        let password = passwordTextField!.text
        
        let trueLogin = UserDefaults.standard.string(forKey: "login")
        let truePassword = UserDefaults.standard.string(forKey: "password")
        
        if (login == trueLogin && password == truePassword) {
            performSegue(withIdentifier: "toMainMenu", sender: sender)
        }
    }
    
}
