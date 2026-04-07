//
//  Page5ViewController.swift
//  Storybook
//
//  Page 5: The Art of Stillness (Kyoto) — Core Animation
//  Drifting mist via CAEmitterLayer and a gently bobbing Tico.
//

import UIKit

class Page5ViewController: StoryPageViewController {

    private var ticoImageView: UIImageView!
    private var emitterLayer: CAEmitterLayer?
    private var hasSetupAnimations = false

    override func setupInteractiveContent() {
        ticoImageView = makeTicoImageView(size: CGSize(width: 100, height: 100))
        ticoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticoImageView)

        NSLayoutConstraint.activate([
            ticoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ticoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            ticoImageView.widthAnchor.constraint(equalToConstant: 300),
            ticoImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasSetupAnimations && view.bounds.width > 0 {
            hasSetupAnimations = true
            setupMistEmitter()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBobbingAnimation()
    }

    // MARK: - Mist (CAEmitterLayer)

    private func setupMistEmitter() {
        let emitter = CAEmitterLayer()
        // Emit from a wide rectangle across the scene for even fog coverage
        emitter.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        emitter.emitterSize = CGSize(width: view.bounds.width * 0.8, height: view.bounds.height * 0.6)
        emitter.emitterShape = .rectangle

        let cell = CAEmitterCell()
        cell.contents = createMistImage().cgImage
        cell.birthRate = 2
        cell.lifetime = 14
        cell.velocity = 8
        cell.velocityRange = 5
        cell.emissionLongitude = 0
        cell.emissionRange = .pi / 4
        cell.scale = 0.6
        cell.scaleRange = 0.3
        cell.alphaSpeed = -0.04
        cell.color = UIColor.white.withAlphaComponent(0.12).cgColor

        emitter.emitterCells = [cell]
        view.layer.insertSublayer(emitter, at: 2)
        emitterLayer = emitter
    }

    private func createMistImage() -> UIImage {
        let size = CGSize(width: 200, height: 80)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(origin: .zero, size: size)
            UIColor.white.withAlphaComponent(0.4).setFill()
            UIBezierPath(ovalIn: rect).fill()
        }
    }

    // MARK: - Tico Bobbing Animation

    private func startBobbingAnimation() {
        UIView.animate(
            withDuration: 2.5,
            delay: 0,
            options: [.repeat, .autoreverse, .curveEaseInOut]
        ) {
            self.ticoImageView.transform = CGAffineTransform(translationX: 0, y: -10)
        }
    }
}
