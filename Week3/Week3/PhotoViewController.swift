//
//  PhotoViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/5/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterContainer: UIView!
    
    var asset : PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set target size to match the primary imageView frame
        var targetSize = CGSizeMake(self.imageView.frame.width, self.imageView.frame.height)
        
        // request the image asset and set it to the primary imageView
        PHImageManager.defaultManager().requestImageForAsset(asset,
            targetSize: targetSize,
            contentMode: PHImageContentMode.AspectFill,
            options: nil) {
                (image, info ) -> Void in
                self.imageView.image = image
            }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowFilters" {
            let filtersVC = segue.destinationViewController as FiltersViewController
            filtersVC.setThumbnailImage(self.asset)
        }
    }

}
