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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver {
    
    let coreMotionManager = CMMotionManager()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func buttonPressedToSelectImage(sender: AnyObject) {
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    var alertController = UIAlertController(title: "Photo Time", message: "Select a photo to edit", preferredStyle: UIAlertControllerStyle.ActionSheet)
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    var imagePicker = UIImagePickerController()
    var cameraPicker : UIImagePickerController? = nil
    
    var filters = Filter()
    var context = CIContext(options: nil)
    var photoAsset : PHAsset!
    var image : UIImage!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var applyingFilter = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if applyingFilter { return }
        if self.photoAsset == nil {
            println("photoAsset is not set, let's check user defaults")
            // try to load from user defaults
            if let assetURL = userDefaults.URLForKey("assetURL") {
                println("read asset from user defaults \(assetURL)")
                var data = NSData.dataWithContentsOfURL(assetURL, options: nil, error: nil)
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func filterSelected(notification : NSNotification) {
        self.applyingFilter = true
        self.photoAsset = notification.userInfo["asset"] as PHAsset
        var filter = notification.userInfo["filter"] as NSString
        self.applyFilterNamed(filter)
//        println("filter = \(filter)")
//        println("photoAsset = \(self.photoAsset)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("filterSelected:"), name: "filterSelectedOnPhotoAsset", object: nil)
        
        // photo library observer
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        // activity indicator - position
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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("didReceiveMemoryWarning")
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
                    self.updateImageView()
                }
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        // ask photo library to save this for us
        let assetCollection = PHAssetCollection()
        
        addNewAssetWithImage(info[UIImagePickerControllerEditedImage] as UIImage, toAlbum: assetCollection)

        self.dismissViewControllerAnimated(true, completion: {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView.image = info[UIImagePickerControllerEditedImage] as UIImage
            })
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func applyFilterNamed(filterNamed : String) {
        if self.photoAsset != nil {
            println("applyFilterNamed \(filterNamed)")
            self.activityIndicator.startAnimating()
            
            // prepare our app specific format identifier and version info
            let inputOptions = PHContentEditingInputRequestOptions()
            inputOptions.canHandleAdjustmentData = { (data : PHAdjustmentData!) -> Bool in
                println("canHandleAdjustmentData \(data.formatIdentifier) \(data.formatVersion)")
                return data.formatIdentifier == "com.kirby.filter" && data.formatVersion == "1.0"
            }
            photoAsset.requestContentEditingInputWithOptions(inputOptions, completionHandler: { (input : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
                
                // get a local copy of the image in CIImage
                var url : NSURL!
                if let urlTest = input.fullSizeImageURL {
                    url = urlTest
                } else {
                    return
                }
                println("setting URL in user defaults \(url)")
                self.userDefaults.setURL(url, forKey: "assetURL")
                
                var orientation = input.fullSizeImageOrientation
                var inputImage = CIImage(contentsOfURL: url)
                inputImage = inputImage.imageByApplyingOrientation(orientation)
                
                var ciImage = CIImage()
                switch filterNamed {
                case "Sepia Tone":
                    // create filter
                    var filter = CIFilter(name: "CISepiaTone")
                    filter.setDefaults()
                    filter.setValue(inputImage, forKey: kCIInputImageKey)
                    // get intensity value from the slider
                    var intensity = CGFloat(0.8)
                    filter.setValue(intensity, forKey:kCIInputIntensityKey)
                    ciImage = filter.outputImage
                case "Vignette":
                    var filter = CIFilter(name: "CIVignette")
                    var radius = NSNumber(double: 1.0)
                    var intensity = 0.0
                    filter.setDefaults()
                    filter.setValue(inputImage, forKey: kCIInputImageKey)
                    filter.setValue(radius, forKey: kCIInputRadiusKey)              // radius
                    filter.setValue(intensity, forKey: kCIInputIntensityKey)         // intensity
                    ciImage = filter.outputImage
                case "Photo Effect Noir":
                    var filter = CIFilter(name: "CIPhotoEffectNoir")
                    filter.setDefaults()
                    filter.setValue(inputImage, forKey: kCIInputImageKey)
                    ciImage = filter.outputImage
                case "Color Invert":
                    var filter = CIFilter(name: "CIColorInvert")
                    filter.setDefaults()
                    filter.setValue(inputImage, forKey: kCIInputImageKey)
                    ciImage = filter.outputImage
                default:
                    println("something wrong")
                }
                
                var cgImage = self.context.createCGImage(ciImage, fromRect: ciImage.extent())
                
                // get a jpeg copy of the image into memory
                var uiImage = UIImage(CGImage: cgImage)
                var jpeg = UIImageJPEGRepresentation(uiImage, 0.7)
                
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
                            self.applyingFilter = false
                            self.activityIndicator.stopAnimating()
                        })
                })
            })
        }
    }
    
    func updateImageView() {
        let targetSize = self.imageView.frame.size  // should this be a constant up above?
        
        PHImageManager.defaultManager().requestImageForAsset(
            self.photoAsset,
            targetSize: targetSize,
            contentMode: PHImageContentMode.AspectFill,
            options: nil) { (image, info) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.imageView.image = image
                })
        }
    }
    
    /**
    Save a new camera photo to the Photo Library
    */
    func addNewAssetWithImage(image: UIImage, toAlbum album:PHAssetCollection) {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            // Request creating an asset from the image.
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            }, completionHandler: { success, error in
                var message = success ? "photo saved!" : "photo not saved\n\(error)"
        })
    }

}