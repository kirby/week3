//
//  HelperFunctions.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/8/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import Photos

func authorizedForPhotoLibrary() -> Bool {
    var photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    println("\(photoLibraryAuthorizationStatus)")
    
    switch photoLibraryAuthorizationStatus {
    case .Authorized:
        return true
    default:
        // TODO - request authorization or display helper
        println("Not Authorized for Photo Library")
        return false
    }
}

func authorizedForAV() -> Bool {
    var audioVideoAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
    switch audioVideoAuthorizationStatus {
    default:
        // TODO - request authorization or display helper
        println("Not Authorized for Camera device")
        return false
    }
}

func isCameraAvailable() -> Bool {
    return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
}