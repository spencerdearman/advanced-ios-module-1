//
//  Page1ViewController.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import UIKit

class Page1ViewController: StoryPageViewController {
    
    private var ticoImageView: UIImageView!
    private var hasAnimated = false
    
    override func setupInteractiveContent() {
        ticoImageView = makeTicoImageView(size: CGSize(width: 300, height: 300))
        ticoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticoImageView)
        
        // Start position: centered horizontally, just above the text area
        NSLayoutConstraint.activate([
            ticoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -120),
            ticoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -220),
            ticoImageView.widthAnchor.constraint(equalToConstant: 300),
            ticoImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAnimated {
            hasAnimated = true
            // Short delay so the user sees Tico before he flies
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.flyAway()
            }
        }
    }
    
    private func flyAway() {
        // Fly toward the top-right corner
        let destination = CGPoint(
            x: view.bounds.width * 0.75,
            y: view.bounds.height * 0.25
        )
        let startCenter = ticoImageView.center
        let dx = destination.x - startCenter.x
        let dy = destination.y - startCenter.y
        
        UIView.animate(
            withDuration: 3.0,
            delay: 0,
            options: .curveEaseInOut
        ) {
            self.ticoImageView.center = destination
            // Slight rotation toward flight direction
            self.ticoImageView.transform = CGAffineTransform(rotationAngle: atan2(dy, dx) * 0.3)
                .scaledBy(x: 0.6, y: 0.6)
        }
    }
}
