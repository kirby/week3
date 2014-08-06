//
//  ViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/4/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos
import CoreMotion

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoSelectedDelegate, PHPhotoLibraryChangeObserver {
    
    let coreMotionManager = CMMotionManager()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filter1Button: UIButton!
    @IBOutlet weak var sepiaSlider: UISlider!
    @IBOutlet weak var sepaiLabel: UILabel!
    
    @IBAction func buttonPressedToSelectImage(sender: AnyObject) {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonPressedApplyFilter1(sender: AnyObject) {
        applyFilter1()
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        self.sepaiLabel.text = NSString(format: "%.01f", sepiaSlider.value)
    }
    
    var alertController = UIAlertController(title: "Photo Time", message: "Select a photo to edit", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var imagePicker = UIImagePickerController()
    var cameraPicker : UIImagePickerController? = nil
    
    var context = CIContext(options: nil)
    var photoAsset : PHAsset!
    var image : UIImage!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.sepaiLabel.text = NSString(format: "%.01f", sepiaSlider.value)
        if self.photoAsset == nil {
            println("photoAsset is not set, let's check user defaults")
            self.filter1Button.enabled = false
            // try to load from user defaults
            if let assetURL = userDefaults.valueForKey("assetURL") as? NSURL {
                println("read asset from user defaults \(assetURL)")
            }
        } else {
            self.filter1Button.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // photo library observer
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        // activity indicator - position
//        self.activityIndicator.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
        self.activityIndicator.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
        self.imageView.addSubview(activityIndicator)
        
//        playTest()
        
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
    
    func playTest() {
        coreMotionManager.startDeviceMotionUpdates()
        coreMotionManager.deviceMotionUpdateInterval = 0.01
        println("deviceMotionActive = \(coreMotionManager.deviceMotionActive)")
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("motionInfo"), userInfo: nil, repeats: true)
        
//        for i in 1...1 {
//            println("\(i)")
//            var timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("motionInfo"), userInfo: nil, repeats: true)
////            println("\(coreMotionManager.deviceMotion!)")
//        }
        coreMotionManager.stopDeviceMotionUpdates()
    }
    
    func motionInfo() {
        println("motionInfo")
        if let motion = coreMotionManager.deviceMotion {
            println("motion = \(motion)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowPhotoCollection" {

            PHPhotoLibrary.authorizationStatus()
            
            let requestOptions = PHFetchOptions()
            let collectionVC = segue.destinationViewController as CollectionViewController
            collectionVC.photoAssets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
            collectionVC.delegate = self
//            println("photoAssets.count = \(collectionVC.photoAssets.count)")
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
    
    // MARK: - PHPhotoLibraryChangeObserver
    
    func photoLibraryDidChange(changeInstance: PHChange!) {
        
        println("photoLibraryDidChange")
        
        // can we break out early
        if self.photoAsset == nil {
            return
        }
        
        // no change
        if let changeDetails = changeInstance.changeDetailsForObject(self.photoAsset) {
            if changeDetails.assetContentChanged {
                if let updatedImage = changeDetails.objectAfterChanges as? PHAsset {
                    self.photoSelected(self.photoAsset)
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {

        self.dismissViewControllerAnimated(true, completion: {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView.image = info[UIImagePickerControllerEditedImage] as UIImage
            })
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyFilter1() {
        if self.photoAsset != nil {
            println("applyFilter1")
            self.activityIndicator.startAnimating()
            
            
            // prepare our app specific format identifier and version info
            let inputOptions = PHContentEditingInputRequestOptions()
            inputOptions.canHandleAdjustmentData = { (data : PHAdjustmentData!) -> Bool in
                println("canHandleAdjustmentData \(data.formatIdentifier) \(data.formatVersion)")
                return data.formatIdentifier == "com.kirby.filter" && data.formatVersion == "1.0"
            }
            photoAsset.requestContentEditingInputWithOptions(inputOptions, completionHandler: { (input : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
                
                // get a local copy of the image in CIImage
                var url = input.fullSizeImageURL
                println("setting URL in user defaults \(url)")
                self.userDefaults.setURL(url, forKey: "assetURL")
                var inputImage = CIImage(contentsOfURL: url)
                
                // create filter
                var filter = CIFilter(name: "CISepiaTone")
                filter.setDefaults()
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                
                // get intensity value from the slider
                var intensity = CGFloat(self.sepiaSlider.value)
                println("\(intensity)")
                
                filter.setValue(intensity, forKey:kCIInputIntensityKey) // TODO: get this from a slider?
              
                // apply filter and get output image CIImage, then CGImage, then UIImage
                var ciImage = filter.outputImage
                var cgImage = self.context.createCGImage(ciImage, fromRect: ciImage.extent())
                
                // get a jpeg copy of the image into memory
                var uiImage = UIImage(CGImage: cgImage)
                var jpeg = UIImageJPEGRepresentation(uiImage, 1.0)
                
                var contentEditingOutput = PHContentEditingOutput(contentEditingInput: input)
                var outputURL = contentEditingOutput.renderedContentURL
                jpeg.writeToURL(outputURL, atomically: true)
                
                // create adjustment data for the edit
                var adjustmentData = PHAdjustmentData(formatIdentifier: "com.kirby.filter", formatVersion: "1.0", data: jpeg)
                contentEditingOutput.adjustmentData = adjustmentData
                
                // write a version of the image to the photo library
                PHPhotoLibrary.sharedPhotoLibrary().performChanges(
                    { // change block
                        
                        var request = PHAssetChangeRequest(forAsset: self.photoAsset)
                        request.contentEditingOutput = contentEditingOutput
                        
                    }, completionHandler: { (success : Bool, error : NSError!) -> Void in
                        
                        if !success {
                            println("performChanges failed")
                            println("\(error)")
                        }
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            self.activityIndicator.stopAnimating()
                        })
                })
            })
        }
    }
    
    // MARK: PhotoSelectedDelegate
    
    func photoSelected(asset: PHAsset) {

//        userDefaults.setObject(asset, forKey: "asset")
        self.photoAsset = asset // save this for later use by the filter
        self.filter1Button.enabled = true
        
        let targetSize = self.imageView.frame.size  // is this a constant up above?
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) {
            (image, info) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
//                self.image = image
                self.imageView.image = image
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    self.imageView.transform = CGAffineTransformMakeScale(1.0, -1.0)
                    self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: { (succes : Bool) -> Void in
                        println("animation done")
                })
            })
        }
    }

}