//
//  User.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/9/16.
//
//
import Firebase
import Foundation


struct User {
    
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
