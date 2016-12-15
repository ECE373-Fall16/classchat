override func didPressAccessoryButton(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
        picker.sourceType = UIImagePickerControllerSourceType.camera
    } else {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
    }
    
    present(picker, animated: true, completion:nil)
}
