//
//  AppDelegate.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/2/16.
//  Copyright © 2016 Everaldlee Johnson. All rights reserved.
//
import UIKit
import Firebase


var gname = ""
var gemail = ""
var displayName = ""


func displayNameChooser(){
	if (gname != ""){
		displayName = gname
	}else{
		displayName = gemail
	}
	
}

class LoginViewController: UIViewController {
	var loginPressed = false
	var registerPressed = false
	var forgotPressed = false
	var TOCPressed = false
	var ProfanityWords = [String]()
	
	
	let loginToList = "LoginToList"
  
  // MARK: Properties
  @IBOutlet weak var nameField: UITextField!
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
	 loginPressed = true
	 registerPressed = false
	 forgotPressed = false
	TOCPressed = false
		let umasscheck = emailField.text
    if ((emailField?.text != "") && (passwordField?.text != "") && (!containsProfanity(text: self.nameField.text!, Profanity: ProfanityWords)) && ((umasscheck?.hasSuffix("umass.edu"))! || (emailField?.text == "alexj2space@gmail.com"))){
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
		}else if let user = FIRAuth.auth()?.currentUser{
			if (!user.isEmailVerified){
				let alert = UIAlertController(title: "Email is not Verified",
				                              message: "Please verify " + self.emailField.text! + " is correct and try again",
				                              preferredStyle: .alert)
				
				let okayAction = UIAlertAction(title: "Okay",
				                               style: .default){action in
												user.sendEmailVerification(completion: nil)
				}
				
				alert.addAction(okayAction)
				
				self.present(alert, animated: true, completion: nil)
				
				return

			}
			}
			
			//FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
			//}
            self.performSegue(withIdentifier: "LoginToChat", sender: nil)
			gname = self.nameField.text!
			gemail = self.emailField.text!
        }

	}else if(containsProfanity(text: self.nameField.text!, Profanity: ProfanityWords)){
		let alert = UIAlertController(title: "Error",
		                              message: "No Profanity",
		                              preferredStyle: .alert)
		
		let okayAction = UIAlertAction(title: "Okay",
		                               style: .default)
		
		alert.addAction(okayAction)
		
		present(alert, animated: true, completion: nil)
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
	
	@IBAction func registerDidTouch(_ sender: AnyObject) {
		loginPressed = false
		registerPressed = true
		forgotPressed = false
		TOCPressed = false
		performSegue(withIdentifier: "ToRegister", sender: self)
	}
	
    @IBAction func forgotDidTouch(_ sender: AnyObject){
		loginPressed = false
		registerPressed = false
		forgotPressed = true
		TOCPressed = false
		performSegue(withIdentifier: "ToForgot", sender: self)
    }
	
	@IBAction func TOCDidTouch(_ sender: AnyObject) {
		loginPressed = false
		registerPressed = false
		forgotPressed = false
		TOCPressed = true
		performSegue(withIdentifier: "ToTOC", sender: self)
	}
	
	
	func containsProfanity(text: String, Profanity: [String]) -> Bool {
		return Profanity
			.reduce(false) { $0 || text.lowercased() == ($1.lowercased()) }
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		do {
			// This solution assumes  you've got the file in your bundle
			if let path = Bundle.main.path(forResource: "ProfanityFile", ofType: "txt"){
				let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
				ProfanityWords = data.components(separatedBy: "\r\n")
			}
		} catch let err as NSError {
			print("Error with importing file")
			print(err)
		}

	
		
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
	if loginPressed {
		let navVc = segue.destination as! UINavigationController
		let channelVc = navVc.viewControllers.first as! ChannelListViewController
		
		channelVc.senderDisplayName = emailField?.text
	}else{
		
	}
	
  }
  
  // MARK: - Notificat.ions
	
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
