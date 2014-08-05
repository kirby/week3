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

class CollectionViewController: UIViewController, UICollectionViewDataSource, PhotoSelectedDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var targetSize : CGSize!
    var imageManager = PHCachingImageManager()
    var photoAssets : PHFetchResult!
    var delegate : PhotoSelectedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("CollectionViewController viewDidLoad")
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("CollectionViewController viewWillAppear - setting targetSize")
        let scale = UIScreen.mainScreen().scale
        println("scale = \(scale)")
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
            photoVC.asset = self.photoAssets[indexPath.item] as PHAsset
            photoVC.delegate = self
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        println("numberOfItemsInSection = \(self.photoAssets.count)")
        return self.photoAssets.count
    }

    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        
        println("cellForItemAtIndexPath \(indexPath)")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCell
    
        // Configure the cell
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        let asset = self.photoAssets[indexPath.item] as PHAsset
        println("asset = \(asset)")
        
        self.imageManager.requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image : UIImage!, [NSObject : AnyObject]!) -> Void in
            if (cell.tag == currentTag) {
                if image == nil {
                    println("why is image nil")
                }
                cell.myImageView.image = image
            }
        }
        
        return cell
    }

    // MARK: - PhotoSelectedDelegate
    
    func photoSelected(asset: PHAsset) {
        println("CollectionViewController.photoSelected")
        self.delegate!.photoSelected(asset)
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
