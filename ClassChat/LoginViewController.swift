//
//  AppDelegate.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/2/16.
//  Copyright © 2016 Everaldlee Johnson. All rights reserved.
//
import UIKit
import Firebase

class LoginViewController: UIViewController {
	
	
	let loginToList = "LoginToList"
  
  // MARK: Properties
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var bottomLayoutGuideConstraint: NSLayoutConstraint!


  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  

  @IBAction func loginDidTouch(_ sender: AnyObject) {
	let umasscheck = emailField.text
    if ((emailField?.text != "") && (passwordField?.text != "") && (umasscheck?.hasSuffix("umass.edu"))!) || emailField?.text == "alexj2space@gmail.com" {
        FIRAuth.auth()!.signIn(withEmail: emailField.text!, password: passwordField.text!){ (user, error) in
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
			FIRAuth.auth()!.addStateDidChangeListener() { auth, user in

				
			}
            self.performSegue(withIdentifier: "LoginToChat", sender: nil)
        }
	}else{
	let alert = UIAlertController(title: "Error",
	                              message: "Please Enter Valid UMass Email and Password or Register!",
	                              preferredStyle: .alert)
		
		let okayAction = UIAlertAction(title: "Okay",
		                                 style: .default)
		
		alert.addAction(okayAction)
		
		present(alert, animated: true, completion: nil)
	
	}
    }
	
	
	@IBAction func signUpDidTouch(_ sender: AnyObject) {
		let alert = UIAlertController(title: "Register!",
		                              message: "Please Register",
		                              preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: "Register",
		                               style: .default) { action in
										let FnameField = alert.textFields![0]
										let emailField = alert.textFields![1]
										let passwordField = alert.textFields![2]
										let vpasswordField = alert.textFields![3]
										let umassemail = emailField.text
										
										
										if (umassemail?.hasSuffix("umass.edu"))! && (FnameField.text != "") && (emailField.text != "") && (passwordField.text != "") && (passwordField.text == vpasswordField.text) {
											
											
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
													                               style: .default)
													
													alert.addAction(okayAction)
													
													self.present(alert, animated: true, completion: nil)
												}
											}
										}else if ((FnameField.text == "") || (emailField.text == "") || (passwordField.text == "") || (vpasswordField.text == "")){
											let alert = UIAlertController(title: "Error",
											                              message: "Please Fill in all Fields and try again",
											                              preferredStyle: .alert)
											
											let okayAction = UIAlertAction(title: "Okay",
											                               style: .default)
											
											alert.addAction(okayAction)
											
											self.present(alert, animated: true, completion: nil)
											return
											
										}else if !(umassemail?.hasSuffix("umass.edu"))!  {
											let alert = UIAlertController(title: "Error",
											                              message: "The email entered is not a valid UMass email address. Try again",
											                              preferredStyle: .alert)
											
											let okayAction = UIAlertAction(title: "Okay",
											                               style: .default)
											
											alert.addAction(okayAction)
											
											self.present(alert, animated: true, completion: nil)
											return
								
										}else if (passwordField.text != vpasswordField.text) {
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
		
		
		
		let cancelAction = UIAlertAction(title: "Cancel",
		                                 style: .default)
		alert.addTextField { textFName in
			textFName.placeholder = " Enter your First & Last name"
		}
		
		alert.addTextField { textEmail in
			textEmail.keyboardType = UIKeyboardType.emailAddress
			textEmail.placeholder = "Enter your UMass email "
		}
		
		alert.addTextField { textPassword in
			textPassword.isSecureTextEntry = true
			textPassword.placeholder = "Enter your password"
		}
		alert.addTextField { textPassword in
			textPassword.isSecureTextEntry = true
			textPassword.placeholder = "Verify your password"
		}
		
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true, completion: nil)
	}
	

    @IBAction func forgotDidTouch(_ sender: AnyObject){
        let alert = UIAlertController(title: "Forgot?",
                                      message: "Please enter your email address",
                                      preferredStyle: .alert)
		
        let resetAction = UIAlertAction(title: "Reset",
                                        style: .default) { action in
                                            let emailField = alert.textFields![0]
											let umassemail = emailField.text
											if (emailField.text != "") && (umassemail?.hasSuffix("umass.edu"))!{
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
													                               style: .default)
													
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
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        
        alert.addTextField { textEmail in
			textEmail.keyboardType = UIKeyboardType.emailAddress
            textEmail.placeholder = "Enter your email"
        }
      
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
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



	
  // MARK: Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    let navVc = segue.destination as! UINavigationController
    let channelVc = navVc.viewControllers.first as! ChannelListViewController
    
    channelVc.senderDisplayName = emailField?.text
  }
  
  // MARK: - Notifications
  
  func keyboardWillShowNotification(_ notification: Notification) {
    let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
    bottomLayoutGuideConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
  }
  
  func keyboardWillHideNotification(_ notification: Notification) {
    bottomLayoutGuideConstraint.constant = 140
  }
}

extension LoginViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == emailField {
			passwordField.becomeFirstResponder()
		}
		if textField == passwordField {
			textField.resignFirstResponder()
		}
		return true
}

}
