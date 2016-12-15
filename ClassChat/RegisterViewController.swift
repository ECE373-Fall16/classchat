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
    //@IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifypasswordField: UITextField!
    @IBOutlet weak var majorField: UITextField!
    

    
    @IBAction func registerDidTouch(_ sender: AnyObject) {
        let umasscheck = emailField.text
        if (umasscheck!.hasSuffix("umass.edu")) && (emailField.text != "") && (passwordField.text != "") && (passwordField.text == verifypasswordField.text) {
            
            
            FIRAuth.auth()!.createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
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
                }else{
                    
                    FIRAuth.auth()!.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!)
                    let user = FIRAuth.auth()?.currentUser
                    user?.sendEmailVerification()
                    let alert = UIAlertController(title: "Success!",
                                                  message: "A verification email was sent and your profile was created",
                                                  preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Okay",
                                                   style: .default) { action in
                                                    self.performSegue(withIdentifier: "BackToLogin", sender: self)
                    }
                    
                    alert.addAction(okayAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else if ((emailField.text == "") || (passwordField.text == "") || (verifypasswordField.text == "")){
            let alert = UIAlertController(title: "Error",
                                          message: "Please Fill in all Fields and try again",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }else if !(umasscheck?.hasSuffix("umass.edu"))!  {
            let alert = UIAlertController(title: "Error",
                                          message: "The email entered is not a valid UMass email address. Try again",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            return
            
        }else if (passwordField.text != verifypasswordField.text) {
            let alert = UIAlertController(title: "Error",
                                          message: "Passwords do not match. Try Again",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            return
            
            
        }else{
            let alert = UIAlertController(title: "FATAL",
                                          message: "UNKOWN ERROR",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
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

