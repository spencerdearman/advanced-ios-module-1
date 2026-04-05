//
//  PatternGestureRecognizer.swift
//  Storybook
//
//  Custom UIGestureRecognizer subclass for connect-the-dots parental gate validation.
//  Overrides touchesBegan, touchesMoved, touchesEnded to track finger drawing.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class PatternGestureRecognizer: UIGestureRecognizer {

    // The target points the user must trace through in order
    var targetPoints: [CGPoint] = []

    // Radius within which a touch is considered to "hit" a target point
    var hitRadius: CGFloat = 44.0

    // Track which points have been hit in sequence
    private(set) var hitPointIndices: [Int] = []

    // The full path the user has drawn
    private(set) var drawnPath: [CGPoint] = []

    // Whether all target points were successfully connected in order
    private(set) var isPatternComplete: Bool = false

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)

        // Reset tracking state for a new gesture
        hitPointIndices = []
        drawnPath = [location]
        isPatternComplete = false

        checkHit(at: location)
        state = .began
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: view)

        drawnPath.append(location)
        checkHit(at: location)
        state = .changed
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if isPatternComplete {
            state = .ended
        } else {
            state = .failed
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }

    override func reset() {
        super.reset()
        hitPointIndices = []
        drawnPath = []
        isPatternComplete = false
    }

    // MARK: - Hit Detection

    private func checkHit(at point: CGPoint) {
        let nextIndex = hitPointIndices.count
        guard nextIndex < targetPoints.count else { return }

        let target = targetPoints[nextIndex]
        let distance = hypot(point.x - target.x, point.y - target.y)

        if distance <= hitRadius {
            hitPointIndices.append(nextIndex)
            if hitPointIndices.count == targetPoints.count {
                isPatternComplete = true
            }
        }
    }
}
