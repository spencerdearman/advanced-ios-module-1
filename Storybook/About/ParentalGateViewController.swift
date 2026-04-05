//
//  ParentalGateViewController.swift
//  Storybook
//
//  UIKit-based parental gate with a connect-the-dots drawing challenge.
//  Uses custom PatternGestureRecognizer and do-try-throw validation.
//

import UIKit

// MARK: - Drawing Canvas View
class DrawingCanvasView: UIView {
    var drawnPath: [CGPoint] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard drawnPath.count > 1 else { return }

        let path = UIBezierPath()
        path.move(to: drawnPath[0])
        for point in drawnPath.dropFirst() {
            path.addLine(to: point)
        }

        UIColor.systemOrange.setStroke()
        path.lineWidth = 3
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
}

// MARK: - Parental Gate View Controller
class ParentalGateViewController: UIViewController {

    private var drawingView: DrawingCanvasView!
    private var gestureRecognizer: PatternGestureRecognizer!
    private var instructionLabel: UILabel!
    private var statusLabel: UILabel!
    private var dotViews: [UIView] = []
    private var dotsConfigured = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Parental Gate"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !dotsConfigured && drawingView.bounds.width > 0 {
            dotsConfigured = true
            setupDots()
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        instructionLabel = UILabel()
        instructionLabel.text = "Connect the dots in order (1 → 2 → 3 → 4) to continue"
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.font = .systemFont(ofSize: 18, weight: .medium)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionLabel)

        drawingView = DrawingCanvasView()
        drawingView.backgroundColor = .secondarySystemBackground
        drawingView.layer.cornerRadius = 16
        drawingView.clipsToBounds = true
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView)

        statusLabel = UILabel()
        statusLabel.text = ""
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)

        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Reset Drawing", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        retryButton.addTarget(self, action: #selector(resetDrawing), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retryButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            drawingView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            drawingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawingView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            drawingView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            drawingView.widthAnchor.constraint(equalTo: drawingView.heightAnchor),
            drawingView.bottomAnchor.constraint(lessThanOrEqualTo: retryButton.topAnchor, constant: -28),
            {
                let c = drawingView.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -28)
                c.priority = .defaultLow
                return c
            }(),

            statusLabel.bottomAnchor.constraint(equalTo: retryButton.topAnchor, constant: -12),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            retryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        gestureRecognizer = PatternGestureRecognizer(target: self, action: #selector(handlePattern(_:)))
        drawingView.addGestureRecognizer(gestureRecognizer)
    }

    private func setupDots() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews.removeAll()

        let canvasSize = drawingView.bounds.size
        let padding: CGFloat = 60

        // Four corners forming a rectangle pattern
        let dotPositions: [CGPoint] = [
            CGPoint(x: padding, y: padding),
            CGPoint(x: canvasSize.width - padding, y: padding),
            CGPoint(x: canvasSize.width - padding, y: canvasSize.height - padding),
            CGPoint(x: padding, y: canvasSize.height - padding),
        ]

        gestureRecognizer.targetPoints = dotPositions

        for (index, position) in dotPositions.enumerated() {
            let dotSize: CGFloat = 50
            let dotView = UIView(frame: CGRect(
                x: position.x - dotSize / 2,
                y: position.y - dotSize / 2,
                width: dotSize,
                height: dotSize
            ))
            dotView.backgroundColor = .systemBlue
            dotView.layer.cornerRadius = dotSize / 2
            dotView.isUserInteractionEnabled = false

            let label = UILabel(frame: dotView.bounds)
            label.text = "\(index + 1)"
            label.textAlignment = .center
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .bold)
            dotView.addSubview(label)

            drawingView.addSubview(dotView)
            dotViews.append(dotView)
        }
    }

    // MARK: - Gesture Handling

    @objc private func handlePattern(_ recognizer: PatternGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            drawingView.drawnPath = recognizer.drawnPath
            drawingView.setNeedsDisplay()

            // Highlight connected dots
            for (index, dotView) in dotViews.enumerated() {
                dotView.backgroundColor = recognizer.hitPointIndices.contains(index)
                    ? .systemGreen : .systemBlue
            }

        case .ended:
            drawingView.drawnPath = recognizer.drawnPath
            drawingView.setNeedsDisplay()

            do {
                try validatePattern(recognizer)
                statusLabel.text = "Access granted!"
                statusLabel.textColor = .systemGreen

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.navigateToAboutAuthor()
                }
            } catch ParentalGateError.patternIncomplete(let hit, let required) {
                statusLabel.text = "Incomplete: connected \(hit) of \(required) dots. Try again."
                statusLabel.textColor = .systemRed
            } catch ParentalGateError.patternOutOfOrder {
                statusLabel.text = "Dots must be connected in order. Try again."
                statusLabel.textColor = .systemRed
            } catch ParentalGateError.noDrawingDetected {
                statusLabel.text = "No drawing detected. Try again."
                statusLabel.textColor = .systemRed
            } catch {
                statusLabel.text = "Validation failed. Try again."
                statusLabel.textColor = .systemRed
            }

        case .failed:
            drawingView.drawnPath = recognizer.drawnPath
            drawingView.setNeedsDisplay()
            statusLabel.text = "Pattern incomplete. Try again."
            statusLabel.textColor = .systemRed

        default:
            break
        }
    }

    // MARK: - Validation (do-try-throw)

    private func validatePattern(_ recognizer: PatternGestureRecognizer) throws {
        guard !recognizer.drawnPath.isEmpty else {
            throw ParentalGateError.noDrawingDetected
        }

        guard recognizer.isPatternComplete else {
            throw ParentalGateError.patternIncomplete(
                hitCount: recognizer.hitPointIndices.count,
                requiredCount: gestureRecognizer.targetPoints.count
            )
        }

        // Verify points were hit in sequential order
        for (i, index) in recognizer.hitPointIndices.enumerated() {
            guard index == i else {
                throw ParentalGateError.patternOutOfOrder
            }
        }
    }

    // MARK: - Navigation

    private func navigateToAboutAuthor() {
        let aboutVC = AboutAuthorViewController()
        // Replace this VC in the nav stack so Back goes to Home, not the gate
        if var viewControllers = navigationController?.viewControllers {
            viewControllers[viewControllers.count - 1] = aboutVC
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }

    @objc private func resetDrawing() {
        drawingView.drawnPath = []
        drawingView.setNeedsDisplay()
        statusLabel.text = ""
        for dotView in dotViews {
            dotView.backgroundColor = .systemBlue
        }
    }
}
