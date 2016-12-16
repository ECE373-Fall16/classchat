//
//  Class_ChatTest.swift
//  Class ChatTest
//
//  Created by Timothy Reardon on 12/16/16.
//
//

import UIKit
import XCTest
import Firebase
import ClassChat

class DisplayNameChooserTest: XCTestCase {
     let gname = ""
     let gname2 = "Class Chat Name test"
     let gemail = "Test@email.com"
     var displayName = ""

    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
            }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testDisplayname() {
        // This is a test of displayNameChooser
        //The first assertion takes an email and blank name which displayNameChooser should return the email
        XCTAssertTrue(displayNameChooserT(name: gname, email: gemail) == gemail)
        //The second assertion takes a name and an email and displayNameChooser should return the name
       XCTAssertTrue(displayNameChooserT(name: gname2, email: gemail) == gname2)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
