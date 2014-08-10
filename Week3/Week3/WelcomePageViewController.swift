//
//  WelcomePageViewController.swift
//  Week3
//
//  Created by Kirby Shabaga on 8/9/14.
//  Copyright (c) 2014 Worxly. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController, UIPageViewControllerDataSource {
   
    var index : Int = 0
    var screenText = [
        "Welcome to Week 3!",
        "Photo Album Permission",
        "Camera Permission"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        if let initialViewController = self.viewControllerAtIndex(0) {
            let viewControllers = [initialViewController]
            
            self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - WelcomePageViewController
    
    func viewControllerAtIndex(index : Int) -> WelcomeViewController? {
        
        if index < 0 || index > (self.screenText.count - 1) { return nil }
        
        let vc = self.storyboard.instantiateViewControllerWithIdentifier("WelcomePageContent") as WelcomeViewController
        self.index = index
        vc.index = index
        vc.screenText = self.screenText[index]
        
        return vc
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
        
        var index = (viewController as WelcomeViewController).index
        return self.viewControllerAtIndex(index + 1)

    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
        
        var index = (viewController as WelcomeViewController).index
        return self.viewControllerAtIndex(index - 1)
    }
}
