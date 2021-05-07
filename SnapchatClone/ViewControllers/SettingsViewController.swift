//
//  SettingsViewController.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 2.05.2021.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func settingsButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "tosigninvc", sender: nil)
        } catch  {
            print("Error")
        }
        
        
    }
   
}
