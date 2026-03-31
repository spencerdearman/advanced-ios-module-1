//
//  HomeViewController.swift
//  Storybook
//
//  Created by Spencer Dearman on 3/30/26.
//

import SwiftUI
import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the SwiftUI view and define the navigation action
        let homeView = HomeView { [weak self] in
            self?.navigateToBook()
        }
        
        // Wrap the SwiftUI view in a UIHostingController
        let hostingController = UIHostingController(rootView: homeView)
        
        // Add the hosting controller to the UIKit view hierarchy
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Set frame to entire screen size
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // Define the onButtonTapped SwiftUI action
    func navigateToBook() {
        // TODO: Create UIPageController and push here
        let pageController = UIViewController()
        pageController.view.backgroundColor = .systemYellow
        pageController.title = "Book Pages"
        
        navigationController?.pushViewController(pageController, animated: true)
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
