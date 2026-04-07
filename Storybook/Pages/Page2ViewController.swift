//
//  Page2ViewController.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import UIKit

class Page2ViewController: StoryPageViewController {
    
    private var ticoImageView: UIImageView!
    private var hasSetInitialPosition = false
    
    override func setupInteractiveContent() {
        ticoImageView = makeTicoImageView(size: CGSize(width: 300, height: 300))
        view.addSubview(ticoImageView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        ticoImageView.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasSetInitialPosition && view.bounds.width > 0 {
            hasSetInitialPosition = true
            ticoImageView.center = CGPoint(x: view.bounds.midX - 290, y: view.bounds.midY - 100)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if let draggedView = gesture.view {
            draggedView.center = CGPoint(
                x: draggedView.center.x + translation.x,
                y: draggedView.center.y + translation.y
            )
        }
        gesture.setTranslation(.zero, in: view)
    }
}
