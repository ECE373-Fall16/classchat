//
//  LoginTest.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/16/16.
//
//



import UIKit
import XCTest
import Firebase
@testable import ClassChat

class LoginViewControllerTest: XCTestCase {

    
    
    
    
    override func setUp() {
        super.setUp()
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "ProfanityFile", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                ProfanityWords = data.components(separatedBy: "\r\n")
            }
        } catch let err as NSError {
            print("Error with importing file")
            print(err)
        }

    }
    
    func testLoginMultiple(){
        let loginView = LoginViewController()
        XCTAssertTrue(loginView.loginFunc(name: "Test", email: "testUser@umass.edu", password: "password"))
        XCTAssertFalse(loginView.loginFunc(name: "", email: "", password: "password"))
        XCTAssertTrue(loginView.loginFunc(name: "", email: "testUser@umass.edu", password: "password"))
        XCTAssertFalse(loginView.loginFunc(name: "Test", email: "", password: "password"))
        XCTAssertFalse(loginView.loginFunc(name: "Test", email: "something@random.com", password: "password"))
        XCTAssertFalse(loginView.loginFunc(name: "Test", email: "something@random.com", password: ""))
        XCTAssertFalse(loginView.loginFunc(name: "Test", email: "", password: ""))
         XCTAssertFalse(loginView.loginFunc(name: "fuck", email: "testUser", password: "password"))

    }
    
    func actualLogin(){
        
    }
    
    
    
    
    
    
    
    
}
