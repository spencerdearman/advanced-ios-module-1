//
//  AboutAuthorViewController.swift
//  Storybook
//

import SwiftUI
import UIKit

class AboutAuthorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About the Author"

        let aboutView = AboutAuthorView()
        let hostingController = UIHostingController(rootView: aboutView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
