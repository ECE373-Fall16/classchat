   // 1
   if let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL {
    // Handle picking a Photo from the Photo Library
    // 2
    let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
    let asset = assets.firstObject
    
    // 3
    if let key = sendPhotoMessage() {
        // 4
        asset?.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
            let imageFileURL = contentEditingInput?.fullSizeImageURL
            
            // 5
            let path = "\(FIRAuth.auth()?.currentUser?.uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\(photoReferenceUrl.lastPathComponent)"
            
            // 6
            self.storageRef.child(path).putFile(imageFileURL!, metadata: nil) { (metadata, error) in
                if let error = error {
                    print("Error uploading photo: \(error.localizedDescription)")
                    return
                }
                // 7
                self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
            }
        })
    }
   } else {
        

   
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
        loginPressed = false
        registerPressed = false
        forgotPressed = true
        TOCPressed = false
        
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

   
   }
   
   
   
   var ProfanityWords = [String]()
   
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


   
   func containsProfanity(text: String, Profanity: [String]) -> Bool {
    return Profanity
        .reduce(false) { $0 || text.lowercased().contains($1.lowercased()) }
   }
   
   if (!containsProfanity(text: text!, Profanity: ProfanityWords)){
    let itemRef = messageRef.childByAutoId()
   
   
