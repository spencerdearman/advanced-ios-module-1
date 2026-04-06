//
//  HomeViewController.swift
//  Storybook
//

import SwiftUI
import UIKit

class HomeViewController: UIViewController {

    private var hostingController: UIHostingController<HomeView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        refreshHomeView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupHomeView() {
        let hc = UIHostingController(rootView: makeHomeView())
        addChild(hc)
        view.addSubview(hc.view)
        hc.didMove(toParent: self)
        hc.view.frame = view.bounds
        hc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController = hc
    }

    private func refreshHomeView() {
        hostingController?.rootView = makeHomeView()
    }

    private func makeHomeView() -> HomeView {
        let bookmarkPage = UserDefaults.standard.integer(forKey: "bookmarkPage")
        return HomeView(
            bookmarkPage: bookmarkPage,
            onReadBook: { [weak self] in self?.navigateToBook() },
            onRestartBook: { [weak self] in self?.navigateToBookStart() },
            onSettings: { [weak self] in self?.navigateToSettings() },
            onAboutAuthor: { [weak self] in self?.navigateToAboutAuthor() }
        )
    }

    // MARK: - Navigation

    func navigateToBook() {
        let bookmarkPage = UserDefaults.standard.integer(forKey: "bookmarkPage")
        if bookmarkPage > 0 {
            // Resume: skip drawing, go straight to story
            let pageController = PageViewController()
            pageController.initialPage = bookmarkPage
            navigationController?.pushViewController(pageController, animated: true)
        } else {
            // First time: show drawing page first
            let drawingVC = DrawingViewController()
            navigationController?.pushViewController(drawingVC, animated: true)
        }
    }

    func navigateToBookStart() {
        UserDefaults.standard.set(0, forKey: "bookmarkPage")
        let drawingVC = DrawingViewController()
        navigationController?.pushViewController(drawingVC, animated: true)
    }

    func navigateToSettings() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    func navigateToAboutAuthor() {
        let gateVC = ParentalGateViewController()
        navigationController?.pushViewController(gateVC, animated: true)
    }
}
