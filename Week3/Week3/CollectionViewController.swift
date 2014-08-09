//
//  CollectionViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/5/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "PhotoCell"

class CollectionViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var targetSize : CGSize!
    var imageManager = PHCachingImageManager()
    var photoAssets : PHFetchResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        targetSize = CGSize(width: flowLayout.itemSize.width * scale, height: flowLayout.itemSize.height * scale)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPhoto" {
            let photoVC = segue.destinationViewController as PhotoViewController
            var selectedCell = sender as PhotoCell
            var indexPath = self.collectionView.indexPathForCell(selectedCell)
            photoVC.asset = self.photoAssets![indexPath.item] as PHAsset
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        if self.photoAssets == nil {
            return 0
        } else {
            return self.photoAssets!.count
        }
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCell
    
        // Configure the cell
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        if self.photoAssets == nil {
            println("Exception: self.photoAssets is nil")
        } else {
            let asset = self.photoAssets![indexPath.item] as PHAsset
            self.imageManager.requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image : UIImage!, [NSObject : AnyObject]!) -> Void in
                if (cell.tag == currentTag) {
                    if image == nil {
                        println("why is image nil")
                    }
                    cell.myImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */

}
