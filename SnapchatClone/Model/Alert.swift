//
//  Alert.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 6.05.2021.
//

import Foundation
import UIKit
var alert = UIAlertController()
var okButton = UIAlertAction()

public func makeAlert(title: String, message: String)  -> UIAlertController {
    
    alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(okButton)
    
    return alert
}

