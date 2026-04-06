//
//  Page3ViewController.swift
//  Storybook
//
//  Page 3: The Warmth in the Frost (Banff) — Physics-Based Animation
//  Tap to spawn snowflakes that fall with gravity and stack on the ground / bounce off Tico.
//

import UIKit

class Page3ViewController: StoryPageViewController {

    private var ticoImageView: UIImageView!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    private var hasSetupPhysics = false

    override func setupInteractiveContent() {
        ticoImageView = makeTicoImageView(size: CGSize(width: 300, height: 300))
        view.addSubview(ticoImageView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasSetupPhysics && view.bounds.width > 0 {
            hasSetupPhysics = true
            // Tico sheltering near the bottom center
            ticoImageView.center = CGPoint(x: view.bounds.midX + 260, y: view.bounds.height - 150)
            setupPhysics()
        }
    }

    private func setupPhysics() {
        animator = UIDynamicAnimator(referenceView: view)

        gravity = UIGravityBehavior()
        gravity.magnitude = 0.4 // Slower, snow-like fall
        animator.addBehavior(gravity)

        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true

        // Tico's frame as a static collision boundary
        let ticoPath = UIBezierPath(roundedRect: ticoImageView.frame, cornerRadius: 150)
//        let ticoPath = UIBezierPath(rect: ticoImageView.frame)
        collision.addBoundary(withIdentifier: "tico" as NSCopying, for: ticoPath)
        animator.addBehavior(collision)

        // Snowflake physics — light, slight bounce
        itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 0.3
        itemBehavior.density = 0.2
        itemBehavior.resistance = 0.5
        animator.addBehavior(itemBehavior)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard animator != nil else { return }

        let tapPoint = gesture.location(in: view)

        // Spawn a cluster of snowflakes at the tap's x-position, near the top
        let count = Int.random(in: 3...6)
        for _ in 0..<count {
            let size = CGFloat.random(in: 6...14)
            let xOffset = CGFloat.random(in: -30...30)
            let snowflake = UIView(frame: CGRect(
                x: tapPoint.x + xOffset - size / 2,
                y: CGFloat.random(in: 40...80),
                width: size,
                height: size
            ))
            snowflake.backgroundColor = .white
            snowflake.layer.cornerRadius = size / 2
            snowflake.alpha = CGFloat.random(in: 0.6...1.0)
            snowflake.isUserInteractionEnabled = false
            view.addSubview(snowflake)

            gravity.addItem(snowflake)
            collision.addItem(snowflake)
            itemBehavior.addItem(snowflake)
        }
    }
}
