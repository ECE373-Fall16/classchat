//
//  Profile.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/10/16.
// 
//

import Firebase


struct Profile {
    
    let uid: String
    let email: String

    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
