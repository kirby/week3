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
import CoreImage

let availableFilters = [ "Sepia Tone", "Vignette", "Photo Effect Noir", "Color Invert" ]
let compressionQuality = CGFloat(0.8)

class Filter {

    let context = CIContext(options: nil)
    
//    var filters : Dictionary<String, (UIImage) -> (UIImage)>?
//    init() {
//        self.filters!["CISepiaTone"] = self.sepiaFilter
//        self.filters!["CISepiaTone2"] = self.sepiaFilter
//        self.filters!["CISepiaTone3"] = self.sepiaFilter
//        self.filters!["CISepiaTone4"] = self.sepiaFilter
////        var sepiaMethod = self.filters!["CISepiaTone"]
////        sepiaMethod!()
//    }
    
    func applyFilterToImage(filterNamed : String, image : UIImage) -> UIImage {
        let context = CIContext(options: nil)

        // create filter
//        println("apply filter named: \(filterNamed)")
        
        var ciImage = CIImage()
        switch filterNamed {
            case "Sepia Tone":
                ciImage = self.sepiaFilter(image)
            case "Vignette":
                ciImage = self.vignetteFilter(image)
            case "Photo Effect Noir":
                ciImage = self.photoNoirFilter(image)
            case "Color Invert":
                ciImage = self.colorInvert(image)
        default:
            println("something wrong")
        }
        
        var cgImage = context.createCGImage(ciImage, fromRect: ciImage.extent())
        
        return UIImage(CGImage: cgImage)
    }
    
    func sepiaFilter(image : UIImage) -> CIImage {
        var filter = CIFilter(name: "CISepiaTone")
        
        var intensity = 0.8
        filter.setDefaults()
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter.setValue(intensity, forKey:kCIInputIntensityKey)

        return filter.outputImage
    }
    
    func vignetteFilter(image : UIImage) -> CIImage {
        var filter = CIFilter(name: "CIVignette")
        
        var radius = NSNumber(double: 1.0)
        var intensity = 0.0
        filter.setDefaults()
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)              // radius
        filter.setValue(intensity, forKey: kCIInputIntensityKey)         // intensity
        
        return filter.outputImage
    }
    
    func photoNoirFilter(image : UIImage) -> CIImage {
        var filter = CIFilter(name: "CIPhotoEffectNoir")

        filter.setDefaults()
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        
        return filter.outputImage
    }
    
    func colorInvert(image : UIImage) -> CIImage {
        var filter = CIFilter(name: "CIColorInvert")
        
        filter.setDefaults()
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        
        return filter.outputImage
    }
    
}