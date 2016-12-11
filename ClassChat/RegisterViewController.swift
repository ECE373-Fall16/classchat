//
//  RegisterViewController.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/11/16.
//
//

import Foundation
import Firebase



class RegisterViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifypasswordField: UITextField!
    @IBOutlet weak var majorField: UITextField!

    
    @IBAction func registerDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "BackToLogin", sender: self)
    }
    
    @IBAction func cancelDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "BackToLogin", sender: self)
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    
    
}

