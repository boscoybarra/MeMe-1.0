//
//  ViewController.swift
//  ImagePickerSimple
//
//  Created by J B on 5/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Properties
    
    var memes = [Meme]()
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // MARK: Text Attributes
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3,
        NSBackgroundColorAttributeName: UIColor.clear
        ] as [String : Any]
    
    // MARK: Text Field Delegate objects
    
    var memedImage = UIImage()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: UI Setup
    
    func setInitialView() {
        
        imagePickerView.image = nil
        setupTextFieldWithDefaultSettings(topText, withText: "TOP")
        setupTextFieldWithDefaultSettings(bottomText, withText: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    func setupTextFieldWithDefaultSettings(_ textField: UITextField, withText text: String) {
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.borderStyle = .none
    }
    
    
    // MARK: Display Image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        } else {
            print("Something went wrong")
        }
        
        imagePickerView.contentMode = .scaleAspectFit
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Save
    
    func save() {
        
        let memedImage = generateMemedImage()
        
        let _ = Meme(topText: topText.text!, bottomText: bottomText.text!, imagePickerView: imagePickerView.image!, memedImage: memedImage)
        
        
    }
    
    // MARK: Generate Meme Image
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        self.navigationBar.isHidden = true
        self.toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        self.navigationBar.isHidden = false
        self.toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Text fields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: IBActions
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveAndShare(_ sender: UIBarButtonItem) {
        let memedImage: UIImage = self.generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            (activityType, complete, returnedItems, activityError ) in
           
            print("Hello!")
            
            
        }
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: Dismiss Meme
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Notifications
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }

}

