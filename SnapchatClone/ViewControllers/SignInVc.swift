//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 1.05.2021.
//

import UIKit
import Firebase

class SignInVc: UIViewController {

    @IBOutlet weak var passwordTexxt: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if passwordTexxt.text != "" && emailText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordTexxt.text!) { Auth, Error in
                if Error != nil {
                    self.makeAlert(title: "Error", message: Error?.localizedDescription ?? "error")
                }else {
                    self.performSegue(withIdentifier: "tofeedvc", sender: nil)
                }
                
            }
            
        }
        else {
            makeAlert(title: "Error", message: "Username / E-mail / Password is empty ?")
        }
        
        
    }
    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordTexxt.text != "" && emailText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordTexxt.text!) { AuthData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                }else {
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["e-mail": self.emailText.text!,"username": self.usernameText.text!] as [String : Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil {
                            
                        }
                    }
                    
                    self.performSegue(withIdentifier: "tofeedvc", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(title: "Error", message: "Username / E-mail / Password is empty ?")
        }
    }
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    

}

