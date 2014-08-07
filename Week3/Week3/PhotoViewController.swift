//
//  PhotoViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/5/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

protocol PhotoSelectedDelegate {
    func photoSelected(asset : PHAsset)
}

class PhotoViewController: UIViewController, FilterAppliedDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterContainer: UIView!
    
    var asset : PHAsset!
    var delegate : PhotoSelectedDelegate?
    var filterDelegate : FilterAppliedDelegate?
    
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
                // show filters view
            }
    }
    
    @IBAction func buttonPressedToEditPhoto(sender: AnyObject) {
//        self.delegate!.photoSelected(self.asset)
        NSNotificationCenter.defaultCenter().postNotificationName("photoChangedNotification", object: nil, userInfo: nil)
        self.navigationController.popToRootViewControllerAnimated(true)
    }

    // MARK: - FilterAppliedDelegate

    func filterAppledUpdatedImage(image: UIImage) {
        println("filter applied, need to update my image")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        println("prepareForSegue to \(segue.identifier)")
        if segue.identifier == "ShowFilters" {
            let filtersVC = segue.destinationViewController as FiltersViewController
            filtersVC.setThumbnailImage(self.asset)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
