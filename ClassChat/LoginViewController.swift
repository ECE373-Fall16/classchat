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
    if (emailField?.text != "") && (passwordField?.text != "") {
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
            self.performSegue(withIdentifier: "LoginToChat", sender: nil)
			if let user = FIRAuth.auth()?.currentUser {
				let name = user.displayName
				let email = user.email
				let photoUrl = user.photoURL
				let uid = user.uid;
			}
        }
	}else{
	let alert = UIAlertController(title: "Error",
	                              message: "Please Enter Email and Password or Register!",
	                              preferredStyle: .alert)
		
		let okayAction = UIAlertAction(title: "Okay",
		                                 style: .default)
		
		alert.addAction(okayAction)
		
		present(alert, animated: true, completion: nil)
		
		//aidfadsfasdfahldsfasdfadsfasdfsdfasdfadsfadsfasdfasdf

		
		
		
	}
    }
	
	
    
    
//    if emailField?.text != "" {
////        if let err:Error = error {
//          print(err.localizedDescription)
//          return
//        }
        
//        self.performSegue(withIdentifier: "LoginToChat", sender: nil)
//      })
//    }
//  }
	
	
	
	
	
	
	
	
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register!",
                                      message: "Please Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        // 1
                                        let FnameField = alert.textFields![0]
                                        let emailField = alert.textFields![1]
                                        let passwordField = alert.textFields![2]
										let vpasswordField = alert.textFields![3]
                                        
                                        
                                        // 2
										
										
										
										if (emailField.text != "") && (passwordField.text != ""){
											if (FnameField.text == ""){
												let alert = UIAlertController(title: "Error",
												                              message: "Please Enter First and Last Name",
												                              preferredStyle: .alert)
												
												let okayAction = UIAlertAction(title: "Okay",
												                               style: .default)
												
												alert.addAction(okayAction)
												
												self.present(alert, animated: true, completion: nil)
												return
												
												
												
											}
											if (passwordField.text != vpasswordField.text){
												let alert = UIAlertController(title: "Error",
												                              message: "Passwords do not match. Try Again",
												                              preferredStyle: .alert)
												
												let okayAction = UIAlertAction(title: "Okay",
												                               style: .default)
												
												alert.addAction(okayAction)
												
												self.present(alert, animated: true, completion: nil)
												return
											}

											
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
												if let user = user {
													let changeRequest = user.profileChangeRequest()
													
													changeRequest.displayName = FnameField.text
													changeRequest.photoURL =
														NSURL(string: "https://example.com/jane-q-user/profile.jpg") as URL?
													changeRequest.commitChanges { error in
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

														} else {
															let alert = UIAlertController(title: "Success!",
															                              message: "A verification email was sent and your profile was created",
															                              preferredStyle: .alert)
															
															let okayAction = UIAlertAction(title: "Okay",
															                               style: .default)
															
															alert.addAction(okayAction)
															
															self.present(alert, animated: true, completion: nil)
														}
													}
												}
												
											}
											
																		
																	
											}
											
                                        }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textFName in
            textFName.placeholder = " Enter your First & Last name"
        }

        alert.addTextField { textEmail in
			textEmail.keyboardType = UIKeyboardType.emailAddress
            textEmail.placeholder = "Enter your email"
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
											if (emailField.text != ""){
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
