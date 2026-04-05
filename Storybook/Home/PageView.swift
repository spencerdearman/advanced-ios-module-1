//
//  PageView.swift
//  Storybook
//

import SwiftUI

struct PageView: View {
    let pageIndex: Int
    let totalPages: Int
    let pageText: String
    let backgroundImage: String
    let textPosition: TextPosition
    var onReturnHome: () -> Void
    var onNextPage: () -> Void
    var onPreviousPage: () -> Void

    @ObservedObject private var soundManager = SoundManager.shared
    @State private var showTapToPlay: Bool = false
    @State private var autoPlayEnabled: Bool = false

    private var isCurrentlySpeakingThisPage: Bool {
        soundManager.isSpeaking && soundManager.currentText == pageText
    }

    var body: some View {
        ZStack {
            // Background image - fills entire screen including safe area
            GeometryReader { geo in
                Image(backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .overlay(Color.black.opacity(0.2))
            }
            .ignoresSafeArea()

            // Top bar: Home button + page indicator
            VStack {
                HStack {
                    Button(action: {
                        soundManager.stop()
                        onReturnHome()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "house.fill")
                            Text("Return to Home")
                        }
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                    }
                    .glassEffect(.regular.interactive(), in: .capsule)

                    Spacer()

                    Text("Page \(pageIndex + 1) of \(totalPages)")
                        .font(.subheadline.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .glassEffect(.regular, in: .capsule)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()
            }

            // Story text positioned based on textPosition
            GeometryReader { geo in
                HighlightedText(
                    text: pageText,
                    highlightRange: isCurrentlySpeakingThisPage
                        ? soundManager.currentSpokenRange
                        : NSRange(location: 0, length: 0),
                    textAlignment: textPosition.textAlignment
                )
                .padding(20)
                .frame(maxWidth: geo.size.width * 0.55)
                .glassEffect(.regular, in: .rect(cornerRadius: 20))
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: textPosition.alignment)
                .padding(.horizontal, 30)
                .padding(.vertical, 80)
            }

            // Bottom controls
            VStack {
                Spacer()

                // Tap-to-play button
                if showTapToPlay {
                    Button(action: {
                        if isCurrentlySpeakingThisPage {
                            soundManager.stop()
                        } else {
                            soundManager.speak(pageText)
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: isCurrentlySpeakingThisPage
                                  ? "stop.fill" : "play.fill")
                            Text(isCurrentlySpeakingThisPage
                                 ? "Stop Reading" : "Read to Me")
                        }
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                    }
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .padding(.bottom, 8)
                }

                // Page navigation buttons
                HStack {
                    if pageIndex > 0 {
                        Button(action: {
                            soundManager.stop()
                            onPreviousPage()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2.bold())
                                .frame(width: 50, height: 50)
                        }
                        .glassEffect(.regular.interactive(), in: .circle)
                    }

                    Spacer()

                    if pageIndex < totalPages - 1 {
                        Button(action: {
                            soundManager.stop()
                            onNextPage()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title2.bold())
                                .frame(width: 50, height: 50)
                        }
                        .glassEffect(.regular.interactive(), in: .circle)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .foregroundStyle(.black)
        .onAppear {
            loadSettings()
            if autoPlayEnabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    soundManager.speak(pageText)
                }
            }
        }
        .onDisappear {
            if isCurrentlySpeakingThisPage {
                soundManager.stop()
            }
        }
    }

    private func loadSettings() {
        autoPlayEnabled = UserDefaults.standard.bool(forKey: "autoPlayEnabled")
        showTapToPlay = UserDefaults.standard.bool(forKey: "tapToPlayEnabled")
    }
}

// MARK: - Highlighted Text (UIViewRepresentable using NSAttributedString)

struct HighlightedText: UIViewRepresentable {
    let text: String
    let highlightRange: NSRange
    var textAlignment: TextAlignment = .center

    private var nsTextAlignment: NSTextAlignment {
        switch textAlignment {
        case .leading: return .left
        case .trailing: return .right
        case .center: return .center
        }
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = nsTextAlignment
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }

    func updateUIView(_ label: UILabel, context: Context) {
        label.textAlignment = nsTextAlignment
        let nsText = text as NSString

        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                .foregroundColor: UIColor.black,
            ]
        )

        if highlightRange.location != NSNotFound
            && highlightRange.length > 0
            && NSMaxRange(highlightRange) <= nsText.length
        {
            attributed.addAttributes(
                [
                    .foregroundColor: UIColor.systemYellow,
                    .backgroundColor: UIColor.systemYellow.withAlphaComponent(0.2),
                    .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                ],
                range: highlightRange
            )
        }

        label.attributedText = attributed
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        guard let width = proposal.width, width > 0 else { return nil }
        uiView.preferredMaxLayoutWidth = width
        let size = uiView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: width, height: size.height)
    }
}
