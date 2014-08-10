//
//  WelcomeViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/9/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    var index : Int!
    var screenText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLabel.text = self.screenText
    }

}
