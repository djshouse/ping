//
//  RegisterViewController.swift
//  PingPal
//
//  Created by DJ on 4/8/18.
//  Copyright © 2018 DJ Rose. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                let currentUser = Auth.auth().currentUser
                let userRef = self.db.collection("users")
                userRef.document(currentUser!.uid).setData([
                    "email": currentUser!.email as Any])
                self.performSegue(withIdentifier: "goToHome", sender: self)
            }
        }
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
