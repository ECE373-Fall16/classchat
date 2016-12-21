//
//  RegisterViewControllerTest.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/21/16.
//
//

import XCTest

class RegisterViewControllerTest: XCTestCase {
    

    func testRegisterMultiple(){
        let registerView = RegisterViewController()
        XCTAssertFalse(registerView.registerUser(email: "", password: "", verifyPassword: ""))
        XCTAssertFalse(registerView.registerUser(email: "", password: "", verifyPassword: "password"))
        XCTAssertFalse(registerView.registerUser(email: "", password: "eggs", verifyPassword: "password"))
        XCTAssertFalse(registerView.registerUser(email: "", password: "password", verifyPassword: "eggs"))
        XCTAssertFalse(registerView.registerUser(email: "testuser", password: "password", verifyPassword: "password"))
        XCTAssertFalse(registerView.registerUser(email: "testuser@gmail.com", password: "password", verifyPassword: "password"))
        XCTAssertFalse(registerView.registerUser(email: "testuser@umass.edu", password: "password", verifyPassword: "Password"))
        XCTAssertFalse(registerView.registerUser(email: "testuser@umass.edu", password: "", verifyPassword: "password"))
        XCTAssertTrue(registerView.registerUser(email: "testuser@umass.edu", password: "password", verifyPassword: "password"))
    }
    
        
        
        
}
