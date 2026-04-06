//
//  Page6ViewController.swift
//  Storybook
//
//  Page 6: The Connected Sky (Serengeti) — SpriteKit Scene
//  Tico as an SKSpriteNode with red dust particles blowing across the African plains.
//

import UIKit
import SpriteKit

class Page6ViewController: StoryPageViewController {

    private var skView: SKView!
    private var hasPresented = false

    override func setupInteractiveContent() {
        skView = SKView()
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skView)

        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: view.topAnchor),
            skView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !hasPresented && skView.bounds.width > 0 {
            hasPresented = true
            presentScene()
        }
    }

    private func presentScene() {
        let sceneSize = skView.bounds.size
        let scene = SKScene(size: sceneSize)
        scene.backgroundColor = .clear
        scene.scaleMode = .resizeFill

        // Tico sprite from saved drawing or default asset
        var ticoImage: UIImage?
        if let data = try? Data(contentsOf: DrawingViewController.ticoDrawingURL) {
            ticoImage = UIImage(data: data)
        }
        ticoImage = ticoImage ?? UIImage(named: "tico")

        if let ticoImage = ticoImage {
            let ticoTexture = SKTexture(image: ticoImage)
            let ticoNode = SKSpriteNode(texture: ticoTexture)
            // Preserve the image's aspect ratio at a reasonable width
            let aspect = ticoImage.size.height / ticoImage.size.width
            let spriteWidth: CGFloat = 280
            ticoNode.size = CGSize(width: spriteWidth, height: spriteWidth * aspect)
            ticoNode.position = CGPoint(x: sceneSize.width * 0.2, y: sceneSize.height * 0.45)
            scene.addChild(ticoNode)
        }

        // Repeating dust particle spawner
        let spawnDust = SKAction.run { [weak scene] in
            guard let scene = scene else { return }
            self.createDustParticle(in: scene)
        }
        let wait = SKAction.wait(forDuration: 0.25, withRange: 0.15)
        scene.run(SKAction.repeatForever(SKAction.sequence([spawnDust, wait])))

        skView.presentScene(scene)
    }

    private func createDustParticle(in scene: SKScene) {
        let size = CGFloat.random(in: 2...7)
        let dust = SKSpriteNode(
            color: UIColor(red: 0.78, green: 0.45, blue: 0.18, alpha: CGFloat.random(in: 0.2...0.5)),
            size: CGSize(width: size, height: size)
        )
        dust.position = CGPoint(
            x: -10,
            y: CGFloat.random(in: 40...scene.size.height * 0.7)
        )
        scene.addChild(dust)

        let duration = Double.random(in: 4...8)
        let drift = CGFloat.random(in: -30...30)
        let moveAcross = SKAction.moveBy(x: scene.size.width + 20, y: drift, duration: duration)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        let remove = SKAction.removeFromParent()
        dust.run(SKAction.sequence([moveAcross, fadeOut, remove]))
    }
}
