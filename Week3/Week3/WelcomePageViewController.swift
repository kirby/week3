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
    var screenTitle = [
        "Welcome to Week 3!",
        "Photo Album Permission",
        "Camera Permission"
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
//        var viewControllers = [WelcomeViewController]()
//        
//        for (index,tmp) in enumerate(screenTitle) {
//            if let vc = self.viewControllerAtIndex(index) {
//                viewControllers.append(vc)
//            }
//        }
        
//        self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        if let initialViewController = self.viewControllerAtIndex(0) {
            let viewControllers = [initialViewController]
            
            self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - WelcomePageViewController
    
    func viewControllerAtIndex(index : Int) -> WelcomeViewController? {
        
        if index < 0 || index > (self.screenTitle.count - 1) { return nil }
        
        let vc = self.storyboard.instantiateViewControllerWithIdentifier("WelcomePageContent") as WelcomeViewController
        self.index = index
        vc.index = index
        vc.screenText = self.screenTitle[index]
        
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
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.screenTitle.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController!) -> Int {
        return self.index
    }
}
