//
//  AppDelegate.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/2/16.
//  Copyright © 2016 Everaldlee Johnson. All rights reserved.
//

import UIKit
import Firebase





enum Section: Int {
  case createNewChannelSection = 0
  case currentChannelsSection
}

class ChannelListViewController: UITableViewController {
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var ProfanityWords = [String]()
    
    var userCountBarButtonItem: UIBarButtonItem!
    var user: User!
    
    let listToUsers = "ListToUsers"

  // MARK: Properties
  var senderDisplayName: String?
  var newChannelTextField: UITextField?
  
  private var channelRefHandle: FIRDatabaseHandle?
  private var channels: [Channel] = []
    private var channelsstring : [String] = []
  
  private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Welcome to Class Chat"
    observeChannels()
    displayNameChooser()

    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    
    FIRAuth.auth()!.addStateDidChangeListener { auth, user in
        guard let user = user else { return }
        self.user = User(authData: user)
        // 1
        let currentUserRef = self.usersRef.child(self.user.uid)
        // 2
        currentUserRef.setValue(self.user.email)
        // 3
        //currentUserRef.onDisconnectRemoveValue()
    }
    usersRef.observe(.value, with: { snapshot in
        if snapshot.exists() {
            self.userCountBarButtonItem?.title = snapshot.childrenCount.description
        } else {
            self.userCountBarButtonItem?.title = "0"
        }
    })

    do {
        // This solution assumes  you've got the file in your bundle
        if let path = Bundle.main.path(forResource: "ProfanityFile", ofType: "txt"){
            let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            ProfanityWords = data.components(separatedBy: "\r\n")
            //dump(ProfanityWords)
        }
    } catch let err as NSError {
        print("Error with importing file")
        print(err)
    }

    
    }
    
    
    func containsProfanity(text: String, Profanity: [String]) -> Bool {
        return Profanity
            .reduce(false) { $0 || text.lowercased() == ($1.lowercased()) }
    }
    
    

    
    
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK :Actions
    
    
    func userCountButtonDidTouch() {
        performSegue(withIdentifier: "onlineUsers", sender: nil)
    }

    
    
  
  @IBAction func createChannel(_ sender: AnyObject) {
    let alert = UIAlertController(title: "New Class",
                                  message: "Please type the name of your class",
                                  preferredStyle: .alert)
    
    let createAction = UIAlertAction(title: "Create",
                                   style: .default) { _ in
                                    
                                    let classField = alert.textFields![0]
                                    if let name = classField.text {
                                        if self.channelsstring.contains(name){
                                            let alert = UIAlertController(title: "Whoops! Class '" + classField.text! + "' Already Exists",
                                                                          message: "Please join that class",
                                                                          preferredStyle: .alert)
                                            
                                            let okayAction = UIAlertAction(title: "Okay Will do",
                                                                           style: .default) { _ in
                                            }
                                            
                                        
                                            alert.addAction(okayAction)
                                            self.present(alert, animated: true, completion: nil)
                                            
                                        }else if(self.containsProfanity(text: classField.text!, Profanity: self.ProfanityWords)){
                                            let alert = UIAlertController(title: "No Profanity",
                                                                          message: "",
                                                                          preferredStyle: .alert)
                                            
                                            let okayAction = UIAlertAction(title: "Okay",
                                                                           style: .default) { _ in
                                            }
                                            
                                            
                                            alert.addAction(okayAction)
                                            self.present(alert, animated: true, completion: nil)

                                            
                                        }else{
                                            self.channelsstring.append(classField.text!)
                                        let newChannelRef = self.channelRef.childByAutoId()
                                        
                                        let channelItem = ["name": name]
                                        newChannelRef.setValue(channelItem)
                                        }
                                    
                                    }
    }
    
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)

    
    alert.addTextField()
   
    alert.addAction(cancelAction)
    alert.addAction(createAction)
    present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func viewProfile(_ sender: AnyObject) {
        performSegue(withIdentifier: "viewProfile", sender: self)
   
    }
    
    func signout(){
        try! FIRAuth.auth()?.signOut()
    }

    
  // MARK: Firebase related methods

  private func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
      let channelData = snapshot.value as! Dictionary<String, AnyObject>
      let id = snapshot.key
      if let name = channelData["name"] as! String!, name.characters.count > 0 {
         self.channelsstring.append(name)
        self.channels.append(Channel(id: id, name: name))
        self.tableView.reloadData()
      } else {
        print("Error! Could not decode channel data")
      }
    })
  }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let channel = sender as? Channel {
      let chatVc = segue.destination as! ChatViewController
      
      chatVc.senderDisplayName = senderDisplayName
      chatVc.channel = channel
      chatVc.channelRef = channelRef.child(channel.id)
    }
  }
  
  // MARK: UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let currentSection: Section = Section(rawValue: section) {
      switch currentSection {
      case .createNewChannelSection:
        return 1
      case .currentChannelsSection:
        return channels.count
      }
    } else {
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

    if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
      if let createNewChannelCell = cell as? CreateChannelCell {
        newChannelTextField = createNewChannelCell.newChannelNameField
      }
    } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
    }
    
    return cell
  }

  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
      let channel = channels[(indexPath as NSIndexPath).row]
      self.performSegue(withIdentifier: "ShowChannel", sender: channel)
    }else{
    print("duck")
    }
  }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            channels.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
    }
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Are you sure you want to log out?",
                                      message: "",
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes",
                                      style: .default) { action in
                                        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                                            guard let user = user else { return }
                                            self.user = User(authData: user)
                                            // 1
                                            let currentUserRef = self.usersRef.child(self.user.uid)

                                            currentUserRef.removeValue()
                                            //self.signout()
                                        }
                                        self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No",
                                       style: .default)

        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        return
    }
  
}
