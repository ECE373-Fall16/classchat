//
//  ProfileViewController.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/11/16.
//  //


import UIKit
import Photos
import Firebase

class ProfileViewController: UIViewController {
    let user = FIRAuth.auth()?.currentUser
    @IBOutlet var userName: UILabel!
    @IBOutlet var userEmail: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
       setUILabel()
        
       
    }
    
    
    func setUILabel() {
        self.userEmail.text = gemail
        self.userName.text = gname
        
        
    }
    
    

    @IBAction func changeEmail(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to change your email?",
                                      message: "",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
                                        self.performSegue(withIdentifier: "changeEmail", sender: nil)
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .default)
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
  
    }
    
    

    @IBAction func changePassword(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to change your password?",
                                      message: "",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
                                        self.performSegue(withIdentifier: "changePassword", sender: nil)
                                                        }
        let noAction = UIAlertAction(title: "No",
                                     style: .default)
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
    }
    
    

    

    @IBAction func deleteAccount(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to delete your account?",
                                      message: "This cannot be undone",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
            
                                        self.user?.delete { error in
                                            if let err: Error = error {
                                                let alert = UIAlertController(title: "Error",
                                                                              message: err.localizedDescription,
                                                                              preferredStyle: .alert)
                                                
                                                let okayAction = UIAlertAction(title: "Okay",
                                                                               style: .default)
                                                
                                                alert.addAction(okayAction)
                                                
                                                self.present(alert, animated: true, completion: nil)
                                            } else {
                                                let alert = UIAlertController(title: "Success",
                                                                              message: "Account Deleted",
                                                                              preferredStyle: .alert)
                                                
                                                let okayAction = UIAlertAction(title: "Okay",
                                                                               style: .default){ action in
                                                                                self.logout()
                                                }
                                                
                                                alert.addAction(okayAction)
                                                
                                                self.present(alert, animated: true, completion: nil)
                                                
                                            
                                            }
                                        }
                                        
        }
        let noAction = UIAlertAction(title: "No",
                                     style: .default)
        
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    
    func logout(){
        dismiss(animated: true, completion: nil)
    }


}

