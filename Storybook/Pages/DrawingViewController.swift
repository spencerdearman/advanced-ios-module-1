//
//  DrawingViewController.swift
//  Storybook
//
//  Standalone coloring page. Uses bird-fill-mask as a CALayer mask on the
//  canvas so colors only appear inside the bird in real time. bird-line-art
//  sits on top for crisp outlines.
//

import UIKit
import PencilKit

class DrawingViewController: UIViewController {

    private var canvasView: PKCanvasView!
    private var lineArtView: UIImageView!
    private var maskLayer: CALayer!
    private var toolPicker: PKToolPicker?
    private var hasAppliedMask = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolPicker = PKToolPicker()
        toolPicker?.setVisible(true, forFirstResponder: canvasView)
        toolPicker?.addObserver(canvasView)
        canvasView.becomeFirstResponder()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Apply the mask once the canvas has its final size
        if !hasAppliedMask && canvasView.bounds.width > 0 {
            hasAppliedMask = true
            applyBirdMask()
        }
    }

    // MARK: - UI

    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Color Tico!"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Gray background container
        let container = UIView()
        container.backgroundColor = UIColor.systemGray6
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        // Canvas — user draws here (will be masked by bird-fill-mask)
        canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(canvasView)

        // Line art on top — touches pass through to canvas
        lineArtView = UIImageView(image: UIImage(named: "bird-line-art"))
        lineArtView.contentMode = .scaleAspectFit
        lineArtView.isUserInteractionEnabled = false
        lineArtView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(lineArtView)

        // Buttons
        let flightButton = UIButton(type: .system)
        flightButton.setTitle(" Take Flight", for: .normal)
        let birdConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        flightButton.setImage(UIImage(systemName: "bird", withConfiguration: birdConfig), for: .normal)
        flightButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        flightButton.tintColor = .white
        flightButton.backgroundColor = .systemBlue
        flightButton.layer.cornerRadius = 22
        flightButton.translatesAutoresizingMaskIntoConstraints = false
        flightButton.addTarget(self, action: #selector(takeFlightTapped), for: .touchUpInside)
        view.addSubview(flightButton)

        let skipButton = UIButton(type: .system)
        skipButton.setTitle("Skip Coloring", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        skipButton.tintColor = .secondaryLabel
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.addSubview(skipButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            flightButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -8),
            flightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flightButton.widthAnchor.constraint(equalToConstant: 220),
            flightButton.heightAnchor.constraint(equalToConstant: 44),

            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 12),
            container.bottomAnchor.constraint(lessThanOrEqualTo: flightButton.topAnchor, constant: -12),
            container.widthAnchor.constraint(equalTo: container.heightAnchor),
            container.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
            container.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.55),
            { let c = container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20); c.priority = .defaultHigh; return c }(),
            { let c = container.widthAnchor.constraint(equalToConstant: 2000); c.priority = .defaultLow; return c }(),

            canvasView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            canvasView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            canvasView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            canvasView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            lineArtView.topAnchor.constraint(equalTo: canvasView.topAnchor),
            lineArtView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor),
            lineArtView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor),
            lineArtView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor),
        ])
    }

    // MARK: - Real-Time Mask

    /// Sets a CALayer mask on the canvas so strokes only appear inside the bird.
    private func applyBirdMask() {
        guard let maskImage = UIImage(named: "bird-fill-mask")?.cgImage else { return }

        let mask = CALayer()
        mask.contents = maskImage
        mask.frame = canvasView.bounds
        mask.contentsGravity = .resizeAspect
        canvasView.layer.mask = mask
    }

    // MARK: - Actions

    @objc private func takeFlightTapped() {
        let compositeImage = createCompositeImage()
        if let data = compositeImage.pngData() {
            try? data.write(to: DrawingViewController.ticoDrawingURL)
        }
        navigateToStory()
    }

    @objc private func skipTapped() {
        try? FileManager.default.removeItem(at: DrawingViewController.ticoDrawingURL)
        navigateToStory()
    }

    static var ticoDrawingURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ticoDrawing.png")
    }

    // MARK: - Navigation

    private func navigateToStory() {
        let pageController = PageViewController()
        pageController.initialPage = 0
        if var viewControllers = navigationController?.viewControllers {
            viewControllers[viewControllers.count - 1] = pageController
            navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }

    // MARK: - Image Composition

    /// Captures the already-masked canvas (which looks perfect on screen)
    /// and composites it with the line art at the bird's native resolution.
    private func createCompositeImage() -> UIImage {
        guard let lineArt = UIImage(named: "bird-line-art"),
              let fillMask = UIImage(named: "bird-fill-mask") else {
            return canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        }

        // Capture the canvas view WITH its CALayer mask already applied.
        // This is exactly what the user sees on screen — no blend modes needed.
        let canvasRenderer = UIGraphicsImageRenderer(bounds: canvasView.bounds)
        let maskedCapture = canvasRenderer.image { _ in
            canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }

        // Compute the aspectFit rect of the bird inside the canvas
        let canvasSize = canvasView.bounds.size
        let imageSize = fillMask.size
        let fitScale = min(canvasSize.width / imageSize.width, canvasSize.height / imageSize.height)
        let fitSize = CGSize(width: imageSize.width * fitScale, height: imageSize.height * fitScale)
        let fitOrigin = CGPoint(
            x: (canvasSize.width - fitSize.width) / 2,
            y: (canvasSize.height - fitSize.height) / 2
        )
        let fitRect = CGRect(origin: fitOrigin, size: fitSize)

        // Crop the capture to just the bird area
        let scale = maskedCapture.scale
        let cropRect = CGRect(
            x: fitOrigin.x * scale,
            y: fitOrigin.y * scale,
            width: fitSize.width * scale,
            height: fitSize.height * scale
        )
        guard let croppedCG = maskedCapture.cgImage?.cropping(to: cropRect) else {
            return maskedCapture
        }
        let croppedDrawing = UIImage(cgImage: croppedCG, scale: scale, orientation: .up)

        // Render at bird's native resolution with line art on top
        let outputSize = imageSize
        let rect = CGRect(origin: .zero, size: outputSize)
        let finalRenderer = UIGraphicsImageRenderer(size: outputSize)

        return finalRenderer.image { _ in
            croppedDrawing.draw(in: rect)
            lineArt.draw(in: rect)
        }
    }
}
