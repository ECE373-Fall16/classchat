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
    var viewController: LoginViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    
    }
    
    func testLoginMultiple(){
        let loginView = LoginViewController()
        XCTAssert(loginView.loginFunc(name: "fuck", email: String, password: String))
        
        
        
        
        
    }
    
}
