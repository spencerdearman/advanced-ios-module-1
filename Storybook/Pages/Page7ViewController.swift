//
//  Page7ViewController.swift
//  Storybook
//
//  Page 7: The Ocean's Rhythm (Australia) — Sound Effects
//  Tico watches the waves. A button plays a splash/wave sound via AVAudioPlayer.
//

import UIKit
import AVFoundation

class Page7ViewController: StoryPageViewController {

    private var ticoImageView: UIImageView!

    /// Strongly retained so playback doesn't stop when the local reference deallocates.
    private var audioPlayer: AVAudioPlayer?

    override func setupInteractiveContent() {
        // Tico — watching from above
        ticoImageView = makeTicoImageView(size: CGSize(width: 300, height: 300))
        ticoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ticoImageView)

        NSLayoutConstraint.activate([
            ticoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 260),
            ticoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            ticoImageView.widthAnchor.constraint(equalToConstant: 300),
            ticoImageView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    override func additionalTopBarItems() -> [UIView] {
        return [makeTopBarButton(title: "Hear the Waves", systemImage: "water.waves", action: #selector(playSplash), tintColor: .systemBlue)]
    }

    @objc private func playSplash() {
        // Try mp3 first, then wav
        let url = Bundle.main.url(forResource: "splash", withExtension: "mp3")
            ?? Bundle.main.url(forResource: "splash", withExtension: "wav")
        guard let soundURL = url else {
            print("splash sound file not found in bundle")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play splash sound: \(error)")
        }
    }
}
