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
@testable import ClassChat






class DisplayNameChooserTest: XCTestCase {
    
        func testdisNameOne(){
            gname = ""
            gemail = "testUser@email.com"
            displayNameChooser()
            print(gname,gemail,displayName)
            XCTAssert(displayName == gemail)
            XCTAssert(displayName != gname)
            return
        }
        
        func testdisNameTwo(){
            gname = "Test User"
            gemail = "testUser@email.com"
            displayNameChooser()
            XCTAssert(displayName != gemail)
            XCTAssert(displayName == gname)
            return
        }

}
