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
    
    var photoAsset : PHAsset!
    var image : UIImage!
    var filters = Array<Filter>()
    var filterDelegate : FilterAppliedDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        for var index = 0; index < availableFilters.count; index++ {
            filters.append(Filter(photoAsset: photoAsset))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        println("numberofItemsInSection")
        return filters.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        println("cellForItemAtIndexPath")
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterViewCell", forIndexPath: indexPath) as FilterViewCell

//        var filteredImage = filters[indexPath.item].previewSepia()
        cell.imageView.image = self.image
        
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
