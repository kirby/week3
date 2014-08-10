//
//  FilterView.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/6/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    var filter : Filter!
    var beforeImage : UIImage!
    var afterImage : UIImage!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func initWith(filter : Filter, image beforeImage : UIImage) {
        self.filter = filter
        self.beforeImage = beforeImage
    }

}
