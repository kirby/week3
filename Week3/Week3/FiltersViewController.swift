//
//  FiltersViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/6/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

class FiltersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func handlePanGesture(sender: AnyObject) {
        println("handlePanGesture")
    }
    var filters = Filter()
    
    // passed in from segue
    var asset : PHAsset!
    var image : UIImage!
    
    var thumbnailSize = CGSize(width: 100, height: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setThumbnailImage(asset : PHAsset) {
        self.asset = asset
        
        PHImageManager.defaultManager().requestImageForAsset(
            asset,
            targetSize: self.thumbnailSize,
            contentMode: PHImageContentMode.AspectFill,
            options: nil) { (image, info) -> Void in
                self.image = image
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        println("numberofItemsInSection")
        return availableFilters.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        println("cellForItemAtIndexPath \(indexPath.row) \(availableFilters[indexPath.row])")
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterViewCell", forIndexPath: indexPath) as FilterViewCell

        var filteredImage = filters.applyFilterToImage(availableFilters[indexPath.row], image: image)
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            cell.imageView.image = filteredImage
            cell.filterLabel.text = availableFilters[indexPath.row]
        }
        
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        println("\(indexPath.item)")
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
