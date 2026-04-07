//
//  SoundManager.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import AVFoundation
import Combine

class SoundManager: NSObject, ObservableObject {
    static let shared = SoundManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var currentSpokenRange: NSRange = NSRange(location: 0, length: 0)
    @Published var isSpeaking: Bool = false
    @Published var currentText: String = ""
    
    private override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func speak(_ text: String) {
        stop()
        currentText = text
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.8
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        isSpeaking = true
        synthesizer.speak(utterance)
    }
    
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentSpokenRange = NSRange(location: 0, length: 0)
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension SoundManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.currentSpokenRange = characterRange
        }
    }
    
    nonisolated func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        didFinish utterance: AVSpeechUtterance
    ) {
        Task { @MainActor in
            self.isSpeaking = false
            self.currentSpokenRange = NSRange(location: 0, length: 0)
        }
    }
}
