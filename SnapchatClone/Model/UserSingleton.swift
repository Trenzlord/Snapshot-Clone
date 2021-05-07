//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Mert Kaan on 5.05.2021.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init() {
        
    }
}
