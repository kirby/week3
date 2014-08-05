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

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var asset : PHAsset!
    var delegate : PhotoSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var targetSize = CGSize()
        targetSize = CGSizeMake(self.imageView.frame.width, self.imageView.frame.height)
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) {
            (image, info ) -> Void in
            self.imageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressedToEditPhoto(sender: AnyObject) {
        println("PhotoViewController buttonPressed")
        self.delegate!.photoSelected(self.asset)
        self.navigationController.popToRootViewControllerAnimated(true)
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
