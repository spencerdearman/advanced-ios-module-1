//
//  StoryPageViewController.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import UIKit
import Combine

/// Base UIKit view controller for interactive story pages.
/// Provides background image, story text overlay, and navigation controls.
/// Subclasses override `setupInteractiveContent()` to add page-specific elements.
class StoryPageViewController: UIViewController {
    
    // MARK: - Configuration
    
    let storyPage: StoryPage
    let pageIndex: Int
    let totalPages: Int
    var onReturnHome: (() -> Void)?
    var onNextPage: (() -> Void)?
    var onPreviousPage: (() -> Void)?
    
    // MARK: - UI Elements
    
    private(set) var backgroundImageView: UIImageView!
    private(set) var textOverlayView: UIVisualEffectView!
    private var storyLabel: UILabel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(storyPage: StoryPage, pageIndex: Int, totalPages: Int) {
        self.storyPage = storyPage
        self.pageIndex = pageIndex
        self.totalPages = totalPages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupBackground()
        setupInteractiveContent()
        setupTextOverlay()
        setupTopBar()
        setupBottomNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Auto-play if enabled in settings
        let autoPlay = UserDefaults.standard.bool(forKey: "autoPlayEnabled")
        if autoPlay {
            let mgr = SoundManager.shared
            // Only start if not already speaking this page
            if !(mgr.isSpeaking && mgr.currentText == storyPage.text) {
                mgr.speak(storyPage.text)
                updateReadButtonForSpeaking(true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let mgr = SoundManager.shared
        if mgr.isSpeaking && mgr.currentText == storyPage.text {
            mgr.stop()
        }
    }
    
    /// Override in subclasses to add interactive content.
    /// Called after background setup but before text overlay and navigation.
    func setupInteractiveContent() {}
    
    // MARK: - Background
    
    private func setupBackground() {
        backgroundImageView = UIImageView(image: UIImage(named: storyPage.backgroundImage))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let dimView = UIView()
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - Text Overlay
    
    private func setupTextOverlay() {
        // Tinted background container using the average color of the page image
        let avgColor = UIImage(named: storyPage.backgroundImage)?.averageColor ?? .black
        let container = UIView()
        container.backgroundColor = avgColor.withAlphaComponent(0.8)
        container.layer.cornerRadius = 20
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        storyLabel = label
        
        applyStoryText(highlightRange: NSRange(location: 0, length: 0))
        
        switch storyPage.textPosition {
        case .topLeading, .bottomLeading, .centerLeading:
            label.textAlignment = .left
        case .topTrailing, .bottomTrailing, .centerTrailing:
            label.textAlignment = .right
        case .topCenter, .bottomCenter:
            label.textAlignment = .center
        }
        
        container.addSubview(label)
        textOverlayView = nil
        
        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -inset),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -inset),
        ])
        
        container.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.55).isActive = true
        
        let hPad: CGFloat = 30
        let vPad: CGFloat = 80
        
        switch storyPage.textPosition {
        case .topLeading:
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: vPad).isActive = true
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPad).isActive = true
        case .topTrailing:
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: vPad).isActive = true
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPad).isActive = true
        case .bottomLeading:
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -vPad).isActive = true
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPad).isActive = true
        case .bottomTrailing:
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -vPad).isActive = true
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPad).isActive = true
        case .centerLeading:
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPad).isActive = true
        case .centerTrailing:
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPad).isActive = true
        case .topCenter:
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: vPad).isActive = true
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        case .bottomCenter:
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -vPad).isActive = true
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
        // Observe SoundManager for word highlighting
        observeSoundManager()
    }
    
    // MARK: - Word Highlighting
    
    private func applyStoryText(highlightRange: NSRange) {
        let text = storyPage.text
        let nsText = text as NSString
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.95)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 6
        
        let baseAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "ShortStack", size: 22) ?? .systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: UIColor.white,
            .shadow: shadow,
            .strokeColor: UIColor.black.withAlphaComponent(0.3),
            .strokeWidth: -1.5,
        ]
        
        let attributed = NSMutableAttributedString(string: text, attributes: baseAttributes)
        
        if highlightRange.location != NSNotFound
            && highlightRange.length > 0
            && NSMaxRange(highlightRange) <= nsText.length
        {
            attributed.addAttributes([
                .foregroundColor: UIColor.systemYellow,
                .backgroundColor: UIColor.systemYellow.withAlphaComponent(0.2),
            ], range: highlightRange)
        }
        
        storyLabel.attributedText = attributed
    }
    
    private func observeSoundManager() {
        let mgr = SoundManager.shared
        
        // Observe spoken range changes for word highlighting
        mgr.$currentSpokenRange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] range in
                guard let self else { return }
                guard mgr.isSpeaking && mgr.currentText == self.storyPage.text else {
                    self.applyStoryText(highlightRange: NSRange(location: 0, length: 0))
                    return
                }
                self.applyStoryText(highlightRange: range)
            }
            .store(in: &cancellables)
        
        // Observe speaking state to reset button and highlighting when speech ends
        mgr.$isSpeaking
            .receive(on: DispatchQueue.main)
            .sink { [weak self] speaking in
                guard let self else { return }
                if !speaking {
                    self.applyStoryText(highlightRange: NSRange(location: 0, length: 0))
                    self.updateReadButtonForSpeaking(false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateReadButtonForSpeaking(_ speaking: Bool) {
        guard let btn = readButton else { return }
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .bold)
        if speaking {
            btn.setImage(UIImage(systemName: "pause.fill", withConfiguration: config), for: .normal)
            btn.setTitle(" Pause", for: .normal)
        } else {
            btn.setImage(UIImage(systemName: "play.fill", withConfiguration: config), for: .normal)
            btn.setTitle(" Read to Me", for: .normal)
        }
    }
    
    // MARK: - Top Bar
    
    private var readButton: UIButton?
    
    private static let topBarFontSize: CGFloat = 14
    private static let topBarIconSize: CGFloat = 13
    
    private func setupTopBar() {
        let fontSize = Self.topBarFontSize
        let iconSize = Self.topBarIconSize
        
        // Left: Home button
        let homeContainer = makeBlurCapsule()
        view.addSubview(homeContainer)
        
        let homeButton = UIButton(type: .system)
        let homeConfig = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .bold)
        homeButton.setImage(UIImage(systemName: "house.fill", withConfiguration: homeConfig), for: .normal)
        homeButton.setTitle(" Return to Home", for: .normal)
        homeButton.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        homeButton.tintColor = .black
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeContainer.contentView.addSubview(homeButton)
        
        NSLayoutConstraint.activate([
            homeButton.topAnchor.constraint(equalTo: homeContainer.contentView.topAnchor, constant: 8),
            homeButton.bottomAnchor.constraint(equalTo: homeContainer.contentView.bottomAnchor, constant: -8),
            homeButton.leadingAnchor.constraint(equalTo: homeContainer.contentView.leadingAnchor, constant: 14),
            homeButton.trailingAnchor.constraint(equalTo: homeContainer.contentView.trailingAnchor, constant: -14),
        ])
        
        // Right side: horizontal stack of capsules
        let rightStack = UIStackView()
        rightStack.axis = .horizontal
        rightStack.spacing = 10
        rightStack.alignment = .fill
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightStack)
        
        // 1. Custom buttons from subclasses (e.g. "Hear the Waves")
        for item in additionalTopBarItems() {
            rightStack.addArrangedSubview(item)
        }
        
        // 2. Read to Me (if enabled)
        let showTapToPlay = UserDefaults.standard.bool(forKey: "tapToPlayEnabled")
        if showTapToPlay {
            let readContainer = makeBlurCapsule()
            let btn = UIButton(type: .system)
            let playConfig = UIImage.SymbolConfiguration(pointSize: iconSize, weight: .bold)
            btn.setImage(UIImage(systemName: "play.fill", withConfiguration: playConfig), for: .normal)
            btn.setTitle(" Read to Me", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
            btn.tintColor = .black
            btn.addTarget(self, action: #selector(readToMeTapped(_:)), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            readContainer.contentView.addSubview(btn)
            readButton = btn
            
            NSLayoutConstraint.activate([
                btn.topAnchor.constraint(equalTo: readContainer.contentView.topAnchor, constant: 8),
                btn.bottomAnchor.constraint(equalTo: readContainer.contentView.bottomAnchor, constant: -8),
                btn.leadingAnchor.constraint(equalTo: readContainer.contentView.leadingAnchor, constant: 14),
                btn.trailingAnchor.constraint(equalTo: readContainer.contentView.trailingAnchor, constant: -14),
            ])
            rightStack.addArrangedSubview(readContainer)
        }
        
        // 3. Page label (rightmost)
        let pageContainer = makeBlurCapsule()
        let pageLabel = UILabel()
        pageLabel.text = "Page \(pageIndex + 1) of \(totalPages)"
        pageLabel.font = .systemFont(ofSize: fontSize, weight: .bold)
        pageLabel.textColor = .black
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        pageContainer.contentView.addSubview(pageLabel)
        
        NSLayoutConstraint.activate([
            pageLabel.topAnchor.constraint(equalTo: pageContainer.contentView.topAnchor, constant: 8),
            pageLabel.bottomAnchor.constraint(equalTo: pageContainer.contentView.bottomAnchor, constant: -8),
            pageLabel.leadingAnchor.constraint(equalTo: pageContainer.contentView.leadingAnchor, constant: 14),
            pageLabel.trailingAnchor.constraint(equalTo: pageContainer.contentView.trailingAnchor, constant: -14),
        ])
        rightStack.addArrangedSubview(pageContainer)
        
        // All capsules share the same height
        for sub in rightStack.arrangedSubviews {
            sub.heightAnchor.constraint(equalTo: homeContainer.heightAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            homeContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            homeContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            rightStack.centerYAnchor.constraint(equalTo: homeContainer.centerYAnchor),
            rightStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    /// Override in subclasses to add custom buttons to the right side of the top bar.
    /// Called before Read to Me and Page label. Use `makeTopBarButton(title:systemImage:action:tintColor:)`.
    func additionalTopBarItems() -> [UIView] { return [] }
    
    /// Creates a blur capsule button matching the top bar style.
    func makeTopBarButton(title: String, systemImage: String, action: Selector, tintColor: UIColor = .black) -> UIVisualEffectView {
        let container = makeBlurCapsule()
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: Self.topBarIconSize, weight: .bold)
        btn.setImage(UIImage(systemName: systemImage, withConfiguration: config), for: .normal)
        btn.setTitle(" \(title)", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: Self.topBarFontSize, weight: .bold)
        btn.tintColor = tintColor
        btn.addTarget(self, action: action, for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        container.contentView.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: container.contentView.topAnchor, constant: 8),
            btn.bottomAnchor.constraint(equalTo: container.contentView.bottomAnchor, constant: -8),
            btn.leadingAnchor.constraint(equalTo: container.contentView.leadingAnchor, constant: 14),
            btn.trailingAnchor.constraint(equalTo: container.contentView.trailingAnchor, constant: -14),
        ])
        return container
    }
    
    @objc private func readToMeTapped(_ sender: UIButton) {
        let mgr = SoundManager.shared
        if mgr.isSpeaking && mgr.currentText == storyPage.text {
            mgr.stop()
        } else {
            mgr.speak(storyPage.text)
            updateReadButtonForSpeaking(true)
        }
    }
    
    // MARK: - Bottom Navigation
    
    private func setupBottomNavigation() {
        if pageIndex > 0 {
            let prevContainer = makeBlurCircle(size: 50)
            view.addSubview(prevContainer)
            
            let prevButton = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
            prevButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
            prevButton.tintColor = .black
            prevButton.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
            prevButton.translatesAutoresizingMaskIntoConstraints = false
            prevContainer.contentView.addSubview(prevButton)
            
            NSLayoutConstraint.activate([
                prevContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                prevContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                prevButton.centerXAnchor.constraint(equalTo: prevContainer.contentView.centerXAnchor),
                prevButton.centerYAnchor.constraint(equalTo: prevContainer.contentView.centerYAnchor),
            ])
        }
        
        if pageIndex < totalPages - 1 {
            let nextContainer = makeBlurCircle(size: 50)
            view.addSubview(nextContainer)
            
            let nextButton = UIButton(type: .system)
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
            nextButton.setImage(UIImage(systemName: "chevron.right", withConfiguration: config), for: .normal)
            nextButton.tintColor = .black
            nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            nextContainer.contentView.addSubview(nextButton)
            
            NSLayoutConstraint.activate([
                nextContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                nextContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                nextButton.centerXAnchor.constraint(equalTo: nextContainer.contentView.centerXAnchor),
                nextButton.centerYAnchor.constraint(equalTo: nextContainer.contentView.centerYAnchor),
            ])
        }
    }
    
    // MARK: - Actions
    
    @objc private func homeTapped() {
        SoundManager.shared.stop()
        onReturnHome?()
    }
    
    @objc private func prevTapped() {
        SoundManager.shared.stop()
        onPreviousPage?()
    }
    
    @objc private func nextTapped() {
        SoundManager.shared.stop()
        onNextPage?()
    }
    
    // MARK: - UI Helpers
    
    private func makeBlurCapsule() -> UIVisualEffectView {
        let blur = CapsuleBlurView(effect: UIBlurEffect(style: .systemMaterial))
        blur.clipsToBounds = true
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }
    
    private func makeBlurCircle(size: CGFloat) -> UIVisualEffectView {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        blur.layer.cornerRadius = size / 2
        blur.clipsToBounds = true
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.widthAnchor.constraint(equalToConstant: size).isActive = true
        blur.heightAnchor.constraint(equalToConstant: size).isActive = true
        return blur
    }
    
    /// Creates a Tico UIImageView using the saved drawing or the default "tico" asset.
    func makeTicoImageView(size: CGSize = CGSize(width: 300, height: 300)) -> UIImageView {
        var ticoImage: UIImage?
        if let data = try? Data(contentsOf: DrawingViewController.ticoDrawingURL) {
            ticoImage = UIImage(data: data)
        }
        ticoImage = ticoImage ?? UIImage(named: "tico")
        
        let imageView = UIImageView(image: ticoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(origin: .zero, size: size)
        imageView.isUserInteractionEnabled = true
        return imageView
    }
}

// MARK: - Capsule Blur View

/// UIVisualEffectView that automatically sets cornerRadius = height/2
/// after layout so it always forms a perfect capsule shape.
private class CapsuleBlurView: UIVisualEffectView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

// MARK: - Average Color

extension UIImage {
    /// Returns the average color of the image by downscaling to 1x1 pixel.
    var averageColor: UIColor? {
        guard let cgImage = cgImage else { return nil }
        let size = CGSize(width: 1, height: 1)
        var pixel: [UInt8] = [0, 0, 0, 0]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixel,
            width: 1, height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        return UIColor(
            red: CGFloat(pixel[0]) / 255,
            green: CGFloat(pixel[1]) / 255,
            blue: CGFloat(pixel[2]) / 255,
            alpha: 1
        )
    }
}
