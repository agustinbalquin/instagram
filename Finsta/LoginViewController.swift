//
//  LoginViewController.swift
//  Finsta
//
//  Created by Agustin Balquin on 6/26/17.
//  Copyright © 2017 Agustin Balquin. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        if usernameField.text!.isEmpty || passwordField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "Username/Password is empty", preferredStyle: .alert)
            
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alertController.addAction(OKAction)
            
            present(alertController, animated: true) {
                
            }
        }
        
        print("hello")
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
//                self.alert202()
            } else {
                print("User Registered successfully")
                // manually segue to logged in view
            }
        }
        
        
    }

    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        print(username)
        print(password)
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            
            if error != nil {
                
                let alertController = UIAlertController(title: "Error", message: "Username/Password is incorrect", preferredStyle: .alert)
                
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true) {
                   
                }
            }
            else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }
    
    
    
    
//    func alert202() {
//        let alertController = UIAlertController(title: "Error", message: "Username is taken", preferredStyle: .alert)
//        
//        // create an OK action
//        let OKAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
//            // handle response here.
//        }
//        alertController.addAction(OKAction)
//        
//        present(alertController, animated: true) {
//            
//        }
//    }



}
