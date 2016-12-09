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
        
