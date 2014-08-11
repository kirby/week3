//
//  Week3CustomView.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/11/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

@IBDesignable class Week3CustomView : UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.blueColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
