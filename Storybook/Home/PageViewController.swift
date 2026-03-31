//
//  UIPageViewController.swift
//  Storybook
//
//  Created by Spencer Dearman on 3/30/26.
//

import SwiftUI
import UIKit

// UIPageViewController docs
// https://developer.apple.com/documentation/uikit/uipageviewcontroller

class PageViewController: UIPageViewController {
    
    // Array hold the UIKit envelopes for each SwiftUI view
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Telling pager that this class handles swipe logic
        self.dataSource = self
        
        // SwiftUI views
        // TODO: maybe add a model for Page or smth so it is easier to do this...
        let page1 = PageView(pageText: "Once upon a time...", backgroundColor: .red) { [weak self] in
            self?.returnToHome()
        }
        let page2 = PageView(pageText: "There was a brave developer...", backgroundColor: .blue) { [weak self] in
            self?.returnToHome()
        }
        
        // Wrap pages in UIHostingControllers and then add them to the array
        pages.append(UIHostingController(rootView: page1))
        pages.append(UIHostingController(rootView: page2))
        
        // Set the initial page to show
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func returnToHome() {
        // Pops pager off the stack, returning to HomeViewController
        navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    // Swipe right (backwards)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        
        // Check if currently on the first page
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    // Swipe left (forwards)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        
        // Check if currently on the last page
        guard nextIndex < pages.count else { return nil }
        
        return pages[nextIndex]
    }
}
