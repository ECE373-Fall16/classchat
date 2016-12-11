//
//  ForgotViewController.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 12/11/16.
//
//

import Foundation
import Firebase



class ForgotViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!

    
    
    @IBAction func resetDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToLoginf", sender: self)
    }
    
    @IBAction func cancelDidTouch(_ sender: AnyObject) {
        performSegue(withIdentifier: "ToLoginf", sender: self)
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
