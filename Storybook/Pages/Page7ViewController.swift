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

        // "Play Wave Sound" button
        let soundButton = UIButton(type: .system)
        let wavesConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        soundButton.setImage(UIImage(systemName: "water.waves", withConfiguration: wavesConfig), for: .normal)
        soundButton.setTitle("  Hear the Waves", for: .normal)
        soundButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        soundButton.tintColor = .white
        soundButton.backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.8, alpha: 1.0)
        soundButton.layer.cornerRadius = 22
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.addTarget(self, action: #selector(playSplash), for: .touchUpInside)
        view.addSubview(soundButton)

        NSLayoutConstraint.activate([
            ticoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 260),
            ticoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            ticoImageView.widthAnchor.constraint(equalToConstant: 300),
            ticoImageView.heightAnchor.constraint(equalToConstant: 300),

            // Position button in the top area so it doesn't overlap with the text
            soundButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            soundButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            soundButton.widthAnchor.constraint(equalToConstant: 240),
            soundButton.heightAnchor.constraint(equalToConstant: 44),
        ])
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
