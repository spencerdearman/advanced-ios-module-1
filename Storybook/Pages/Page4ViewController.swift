//
//  Page4ViewController.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import UIKit

class Page4ViewController: StoryPageViewController {
    
    private var ticoImageView: UIImageView!
    
    override func setupInteractiveContent() {
        ticoImageView = makeTicoImageView(size: CGSize(width: 75, height: 75))
        ticoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticoImageView)
        
        NSLayoutConstraint.activate([
            ticoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -125),
            ticoImageView.widthAnchor.constraint(equalToConstant: 100),
            ticoImageView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: view)
        dropLeaf(at: tapPoint)
    }
    
    private func dropLeaf(at point: CGPoint) {
        let leafSize: CGFloat = CGFloat.random(in: 20...35)
        let colors: [UIColor] = [
            UIColor(red: 0.85, green: 0.55, blue: 0.1, alpha: 0.9),  // orange
            UIColor(red: 0.75, green: 0.2, blue: 0.15, alpha: 0.9),  // red
            UIColor(red: 0.9, green: 0.75, blue: 0.15, alpha: 0.9),  // gold
            UIColor(red: 0.6, green: 0.3, blue: 0.1, alpha: 0.9),    // brown
        ]
        
        let leaf = UIImageView(image: UIImage(systemName: "leaf.fill"))
        leaf.tintColor = colors.randomElement()
        leaf.frame = CGRect(x: point.x - leafSize / 2, y: point.y, width: leafSize, height: leafSize)
        leaf.alpha = 1.0
        leaf.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -.pi...(.pi)))
        leaf.isUserInteractionEnabled = false
        view.addSubview(leaf)
        
        // Animate the leaf floating down and fading
        let fallDistance = view.bounds.height - point.y + 50
        let drift = CGFloat.random(in: -60...60)
        let rotation = CGFloat.random(in: -.pi...(.pi))
        let duration = Double.random(in: 2.5...4.0)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            leaf.center = CGPoint(x: point.x + drift, y: point.y + fallDistance)
            leaf.transform = CGAffineTransform(rotationAngle: rotation)
            leaf.alpha = 0.0
        }
        animator.addCompletion { _ in
            leaf.removeFromSuperview()
        }
        animator.startAnimation()
    }
}
