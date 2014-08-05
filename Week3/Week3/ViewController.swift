//
//  ViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/4/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoSelectedDelegate {
                            
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
        self.imagePicker.allowsEditing = true
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        
        var actionSavedPhotosAlbum = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) in
//            self.presentViewController(self.imagePicker, animated: true, completion: nil)
                println("ViewController performSegue with identifier ShowPhotoCollection")
                self.performSegueWithIdentifier("ShowPhotoCollection", sender: self)
        })
        alertController.addAction(actionSavedPhotosAlbum)
        
        // if available add Camera picker
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            
            self.cameraPicker = UIImagePickerController()
            self.cameraPicker!.allowsEditing = true
            self.cameraPicker!.delegate = self
            self.cameraPicker!.sourceType = UIImagePickerControllerSourceType.Camera
            var actionCamera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
                (action : UIAlertAction!) -> Void in
                println("self.view = \(self.view)\n")
                self.dismissViewControllerAnimated(false, completion: nil)
//                self.alertController.view.removeFromSuperview()
//                self.dismissViewControllerAnimated(false, completion: {
//                    () -> Void in
//                    self.presentViewController(self.cameraPicker, animated: true, completion: nil)
//                })
                self.presentViewController(self.cameraPicker, animated: true, completion: nil)
            })
            alertController.addAction(actionCamera)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
    }
    
    override func viewDidAppear(animated: Bool) {
        println("viewDidAppear")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowPhotoCollection" {

            let requestOptions = PHFetchOptions()
            let collectionVC = segue.destinationViewController as CollectionViewController
            collectionVC.photoAssets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
            collectionVC.delegate = self
            println("photoAssets.count = \(collectionVC.photoAssets.count)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentCameraPicker() {
        self.presentViewController(self.cameraPicker, animated: true, completion: {
            () in
            println("cameraPicker completion")
        })
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        println("didFinishPickingMediaWithInfo")

        self.dismissViewControllerAnimated(true, completion: {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView.image = info[UIImagePickerControllerEditedImage] as UIImage
            })
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: PhotoSelectedDelegate
    
    func photoSelected(asset: PHAsset) {
//        println("load this photo up! \(asset)")
        
        let targetSize = self.imageView.frame.size
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) {
            (image, info) -> Void in
            
            self.imageView.image = image
            
        }
    }

}

