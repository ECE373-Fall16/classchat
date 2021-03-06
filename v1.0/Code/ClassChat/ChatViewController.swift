//
//  AppDelegate.swift
//  ClassChat
//
//  Created by Everaldlee Johnson on 11/2/16.

import UIKit
import Photos
import Firebase
import JSQMessagesViewController



var ProfanityWords = [String]()



final class ChatViewController: JSQMessagesViewController {
  
  // MARK: Properties
  private let imageURLNotSetKey = "NOTSET"
  
  var channelRef: FIRDatabaseReference?

  private lazy var messageRef: FIRDatabaseReference = self.channelRef!.child("messages")
  fileprivate lazy var storageRef: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://class-chat-86460.appspot.com")
  private lazy var userIsTypingRef: FIRDatabaseReference = self.channelRef!.child("typingIndicator").child(self.senderId)
  private lazy var usersTypingQuery: FIRDatabaseQuery = self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

  private var newMessageRefHandle: FIRDatabaseHandle?
  private var updatedMessageRefHandle: FIRDatabaseHandle?
  
  private var messages: [JSQMessage] = []
  private var photoMessageMap = [String: JSQPhotoMediaItem]()
  
  private var localTyping = false
  var channel: Channel? {
    didSet {
      title = channel?.name
    }
  }

  var isTyping: Bool {
    get {
      return localTyping
    }
    set {
      localTyping = newValue
      userIsTypingRef.setValue(newValue)
    }
  }
  
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.senderId = FIRAuth.auth()?.currentUser?.uid
    observeMessages()
    
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
    
    
    // No avatars
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    


  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    observeTyping()
  }
  
  deinit {
    if let refHandle = newMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
    if let refHandle = updatedMessageRefHandle {
      messageRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK: Collection view data source (and related) methods
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item] // 1
    if message.senderId == senderId { // 2
      return outgoingBubbleImageView
    } else { // 3
      return incomingBubbleImageView
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
    
    let message = messages[indexPath.item]
    
    if message.senderId == senderId { // 1
      cell.textView?.textColor = UIColor.white // 2
    } else {
      cell.textView?.textColor = UIColor.black // 3
    }
    
    return cell
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
    return 15
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
    let message = messages[indexPath.item]
    switch message.senderId {
    case senderId:
      return nil
    default:
      guard let senderDisplayName = message.senderDisplayName else {
        assertionFailure()
        return nil
      }
      return NSAttributedString(string: senderDisplayName)
    }
  }
    
    
    // Mark: Censoring Messages
    func containsProfanity(text: String, Profanity: [String]) -> Bool {
        return Profanity
            .reduce(false) { $0 || text.lowercased() == ($1.lowercased()) }
    }
    
    
    

    

  // MARK: Firebase related methods
  
  private func observeMessages() {
    messageRef = channelRef!.child("messages")
    let messageQuery = messageRef.queryLimited(toLast:25)
    
    // We can use the observe method to listen for new
    // messages being written to the Firebase DB
    newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
      let messageData = snapshot.value as! Dictionary<String, String>

      if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0 {
        self.addMessage(withId: id, name: name, text: text)
        self.finishReceivingMessage()
      } else if let id = messageData["senderId"] as String!, let photoURL = messageData["photoURL"] as String! {
        if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
          self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
          
          if photoURL.hasPrefix("gs://") {
            self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
          }
        }
      } else {
        print("Error! Could not decode message data")
      }
    })
    
  
    updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
      let key = snapshot.key
      let messageData = snapshot.value as! Dictionary<String, String>
      
      if let photoURL = messageData["photoURL"] as String! {
        // The photo has been updated.
        if let mediaItem = self.photoMessageMap[key] {
          self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key)
        }
      }
    })
  }
  
  private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
    let storageRef = FIRStorage.storage().reference(forURL: photoURL)
    storageRef.data(withMaxSize: INT64_MAX){ (data, error) in
      if let error = error {
        print("Error downloading image data: \(error)")
        return
      }
      
      storageRef.metadata(completion: { (metadata, metadataErr) in
        if let error = metadataErr {
          print("Error downloading metadata: \(error)")
          return
        }
        
        if (metadata?.contentType == "image/gif") {
          mediaItem.image = UIImage.gifWithData(data!)
        } else {
          mediaItem.image = UIImage.init(data: data!)
        }
        self.collectionView.reloadData()
        
        guard key != nil else {
          return
        }
        self.photoMessageMap.removeValue(forKey: key!)
      })
    }
  }
  
  private func observeTyping() {
    let typingIndicatorRef = channelRef!.child("typingIndicator")
    userIsTypingRef = typingIndicatorRef.child(senderId)
    userIsTypingRef.onDisconnectRemoveValue()
    usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
    
    usersTypingQuery.observe(.value) { (data: FIRDataSnapshot) in
      
      // You're the only typing, don't show the indicator
      if data.childrenCount == 1 && self.isTyping {
        return
      }
      
      // Are there others typing?
      self.showTypingIndicator = data.childrenCount > 0
      self.scrollToBottom(animated: true)
    }
  }
    

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if (!containsProfanity(text: text!, Profanity: ProfanityWords)){
            let itemRef = messageRef.childByAutoId()
            
            // 2
            let messageItem = [
                "senderId": senderId!,
                "senderName": displayName,
                "text": text!,
                ]
            
            // 3
            itemRef.setValue(messageItem)
            

            // 4
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            
            // 5
            finishSendingMessage()
            isTyping = false

        }else{
            let alert = UIAlertController(title: "Error",
                                          message: "Please abstain from using Foul language",
                                          preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "Okay",
                                           style: .default)
            
            alert.addAction(okayAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        isTyping = false

        
    }
    
  func sendPhotoMessage() -> String? {
    let itemRef = messageRef.childByAutoId()
    
    let messageItem = [
      "photoURL": imageURLNotSetKey,
      "senderId": senderId!,
      ]
    
    itemRef.setValue(messageItem)
    
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
    finishSendingMessage()
    return itemRef.key
  }
  
  func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
    let itemRef = messageRef.child(key)
    itemRef.updateChildValues(["photoURL": url])
  }
  
  
  
  private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
  }

  private func setupIncomingBubble() -> JSQMessagesBubbleImage {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
  }

  override func didPressAccessoryButton(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    let alert = UIAlertController(title: "Image Source",
                                  message: "",
                                  preferredStyle: .alert)
    
    let cameraAction = UIAlertAction(title: "Camera",
                                  style: .default) { action in
                                    picker.sourceType = UIImagePickerControllerSourceType.camera
                                    self.present(picker, animated: true, completion:nil)
    }
    let photosAction = UIAlertAction(title: "Photos",
                                  style: .default) { action in
                                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                                    self.present(picker, animated: true, completion:nil)
    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                  style: .default)
    
    
    
    alert.addAction(cameraAction)
    alert.addAction(photosAction)
    alert.addAction(cancelAction)
    
    self.present(alert, animated: true, completion: nil)
    return
    }
    
    
    
    

    //override func didPressAccessoryButton(_ sender: UIButton) {
    //let picker = UIImagePickerController()
    //picker.delegate = self
    //if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
      //picker.sourceType = UIImagePickerControllerSourceType.camera
    //} else {
      //picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    //}
    
    //present(picker, animated: true, completion:nil)
  //}
  
  private func addMessage(withId id: String, name: String, text: String) {
    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
      messages.append(message)      
    }
  }
  
  private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
    if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
      messages.append(message)
      
      if (mediaItem.image == nil) {
        photoMessageMap[key] = mediaItem
      }
      
      collectionView.reloadData()
    }
  }
  
 
  
  override func textViewDidChange(_ textView: UITextView) {
    super.textViewDidChange(textView)
    // If the text is not empty, the user is typing
    isTyping = textView.text != ""
  }
  
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {

    picker.dismiss(animated: true, completion:nil)

 
        // 1
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 2
        if let key = sendPhotoMessage() {
            // 3
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            // 4
            let imagePath = FIRAuth.auth()!.currentUser!.uid + "/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            // 5
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            // 6
            storageRef.child(imagePath).put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading photo: \(error)")
                    return
                }
                // 7
                self.setImageURL(self.storageRef.child((metadata?.path)!).description, forPhotoMessageWithKey: key)
            }
        }
    }
}

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion:nil)
}



