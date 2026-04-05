//
//  PageViewController.swift
//  Storybook
//

import SwiftUI
import UIKit

class PageViewController: UIPageViewController {

    var pages = [UIViewController]()
    var initialPage: Int = 0
    private var currentPageIndex: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self

        let storyPages = StoryPage.allPages
        let totalPages = storyPages.count

        for (index, storyPage) in storyPages.enumerated() {
            let pageView = PageView(
                pageIndex: index,
                totalPages: totalPages,
                pageText: storyPage.text,
                backgroundImage: storyPage.backgroundImage,
                textPosition: storyPage.textPosition,
                onReturnHome: { [weak self] in self?.returnToHome() },
                onNextPage: { [weak self] in self?.goToPage(index + 1, direction: .forward) },
                onPreviousPage: { [weak self] in self?.goToPage(index - 1, direction: .reverse) }
            )
            pages.append(UIHostingController(rootView: pageView))
        }

        // Start at bookmarked page or first page
        let startIndex = min(max(initialPage, 0), pages.count - 1)
        currentPageIndex = startIndex
        if !pages.isEmpty {
            setViewControllers([pages[startIndex]], direction: .forward, animated: false)
        }

        // Save bookmark when app enters background
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveBookmark),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
    }

    // MARK: - Navigation

    func returnToHome() {
        saveBookmark()
        SoundManager.shared.stop()
        navigationController?.popViewController(animated: true)
    }

    func goToPage(_ index: Int, direction: NavigationDirection) {
        guard index >= 0, index < pages.count else { return }
        currentPageIndex = index
        setViewControllers([pages[index]], direction: direction, animated: true)
        saveBookmark()
    }

    // MARK: - Bookmarking

    @objc func saveBookmark() {
        UserDefaults.standard.set(currentPageIndex, forKey: "bookmarkPage")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
              let currentVC = viewControllers?.first,
              let index = pages.firstIndex(of: currentVC)
        else { return }

        currentPageIndex = index
        saveBookmark()
    }
}
