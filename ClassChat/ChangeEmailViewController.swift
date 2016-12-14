//
//  ChangeEmailViewController.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/13/16.
//
//

import Foundation
import Firebase


class ChangeEmailViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var verifyEmailField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Email Address"
        
    }
    
    
    @IBAction func ChangeEmail(_ sender: AnyObject) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



//FIRAuth.auth()?.currentUser?.updatePassword(userInput) { (error) in
//if let err: Error = error {
