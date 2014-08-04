//
//  ViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/4/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
                            
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func buttonPressedToSelectImage(sender: AnyObject) {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var alertController = UIAlertController(title: "Photo Time", message: "Select a photo to edit", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var imagePicker = UIImagePickerController()
    var cameraPicker : UIImagePickerController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add Saved Photos Album image picker
        self.imagePicker = UIImagePickerController()
        self.imagePicker.editing = true
        self.imagePicker.setEditing(true, animated: true)
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        var actionSavedPhotosAlbum = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) in
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(actionSavedPhotosAlbum)
        
        // if available add Camera picker
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            self.cameraPicker = UIImagePickerController()
            self.cameraPicker!.editing = true
            self.cameraPicker!.setEditing(true, animated: true)
            self.cameraPicker!.delegate = self
            self.cameraPicker!.sourceType = UIImagePickerControllerSourceType.Camera
            var actionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction!) in
                    self.presentViewController(self.cameraPicker, animated: true, completion: nil)
                })
            alertController.addAction(actionCamera)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        println("didFinishPickingMediaWithInfo picker = \(picker)")
//        self.imagePicker.setEditing(true, animated: true)
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as UIImage
//        self.imageView.image = (info[UIImagePickerControllerEditedImage] as UIImage)
        // UIImagePickerControllerMediaURL
        // UIImagePickerControllerReferenceURL
        // UIImagePickerControllerMediaMetadata
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}

