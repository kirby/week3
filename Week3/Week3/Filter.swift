//
//  Filter.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/6/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import Foundation
import UIKit
import Photos

class Filter {
    
    var photoAsset : PHAsset!
    var filterName : String!
    var beforeImage : UIImage!
    var afterImage : UIImage!
    
    let compressionQuality = CGFloat(0.5)
    let context = CIContext(options: nil)
    let inputOptions = PHContentEditingInputRequestOptions()
    
    init(photoAsset : PHAsset) {
        self.photoAsset = photoAsset
        // prepare our app specific format identifier and version info
        inputOptions.canHandleAdjustmentData = { (data : PHAdjustmentData!) -> Bool in
            println("canHandleAdjustmentData \(data.formatIdentifier) \(data.formatVersion)")
            return data.formatIdentifier == "com.kirby.filter" && data.formatVersion == "1.0"
        }
    }
    
    func getInputImageFromContentEditingInput(input : PHContentEditingInput) -> CIImage? {
        // get a local copy of the image in CIImage
        var url : NSURL!
        if let urlTest = input.fullSizeImageURL {
            url = urlTest
        } else {
            return nil
        }
        
        var orientation = input.fullSizeImageOrientation
        var inputImage = CIImage(contentsOfURL: url)
        inputImage = inputImage.imageByApplyingOrientation(orientation)
        
        return inputImage
    }
    
    func previewSepia() -> UIImage {
        
        var image : UIImage!
        
        photoAsset.requestContentEditingInputWithOptions(inputOptions, completionHandler: { (input : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
            
            if let inputImage = self.getInputImageFromContentEditingInput(input) {
                
                // create filter
                var filter = CIFilter(name: "CISepiaTone")
                var intensity = 0.8
                filter.setDefaults()
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                filter.setValue(intensity, forKey:kCIInputIntensityKey)
                
                // apply filter and get output image CIImage, then CGImage, then UIImage
                var ciImage = filter.outputImage
                var cgImage = self.context.createCGImage(ciImage, fromRect: ciImage.extent())
                
                // get a jpeg copy of the image into memory
                image = UIImage(CGImage: cgImage)
            }
        })
        
        return image
    }
    
    func applySepia() {
        photoAsset.requestContentEditingInputWithOptions(inputOptions, completionHandler: { (input : PHContentEditingInput!, info : [NSObject : AnyObject]!) -> Void in
 
            if let inputImage = self.getInputImageFromContentEditingInput(input) {
                
                // create filter
                var filter = CIFilter(name: "CISepiaTone")
                var intensity = 0.8
                filter.setDefaults()
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                filter.setValue(intensity, forKey:kCIInputIntensityKey)
                
                // apply filter and get output image CIImage, then CGImage, then UIImage
                var ciImage = filter.outputImage
                var cgImage = self.context.createCGImage(ciImage, fromRect: ciImage.extent())
                
                // get a jpeg copy of the image into memory
                var uiImage = UIImage(CGImage: cgImage)
//                var jpeg = UIImageJPEGRepresentation(uiImage, self.compressionQuality)
//                
//                var contentEditingOutput = PHContentEditingOutput(contentEditingInput: input)
//                var outputURL = contentEditingOutput.renderedContentURL
//                jpeg.writeToURL(outputURL, atomically: true)
            }
        })
    }
}