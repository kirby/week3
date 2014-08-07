//
//  FiltersViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/6/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit
import Photos

protocol FilterAppliedDelegate {
    func filterAppledUpdatedImage(image : UIImage)
}

class FiltersViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var filters = Filter()
    
    // passed in from segue
    var asset : PHAsset!
    var image : UIImage!
    
    var thumbnailSize = CGSize(width: 50, height: 50)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
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
        }
//        cell.imageView.image = self.image
        
        return cell
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
