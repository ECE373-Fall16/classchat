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
import ClassChat

class LoginViewControllerTest: XCTestCase {
    var viewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
}
