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
        let umasscheck = emailField.text
        if (emailField.text != "") && (umasscheck?.hasSuffix("umass.edu"))!{
            FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!) { error in
                if let err: Error = error {
                    print(err.localizedDescription)
                    let alert = UIAlertController(title: "Error",
                                                  message: err.localizedDescription,
                                                  preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay",
                                                   style: .default)
                    
                    alert.addAction(okayAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                let alert = UIAlertController(title: "Success!",
                                              message: "A reset email was sent ",
                                              preferredStyle: .alert)
                
                let okayAction = UIAlertAction(title: "Okay",
                                               style: .default){action in
                                                self.performSegue(withIdentifier: "ToLoginf", sender: self)
                }
                
                alert.addAction(okayAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "Error",
                                          message: "Please enter valid UMass email address and try again",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
  
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
