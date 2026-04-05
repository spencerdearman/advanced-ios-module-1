//
//  HomeView.swift
//  Storybook
//

import SwiftUI

struct HomeView: View {

    var bookmarkPage: Int
    var onReadBook: () -> Void
    var onRestartBook: () -> Void
    var onSettings: () -> Void
    var onAboutAuthor: () -> Void

    var body: some View {
        ZStack {
            // Cover image background
            GeometryReader { geo in
                Image("cover")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .overlay(Color.black.opacity(0.1))
            }
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()
                Spacer()
                Spacer()

                Text("The Incredible Travels of Pico")
                    .font(.system(size: 42, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.7), radius: 6)
                    .multilineTextAlignment(.center)

                Text("by Spencer Dearman")
                    .font(.system(size: 20, weight: .medium, design: .serif))
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.7), radius: 6)

                Spacer()

                VStack(spacing: 10) {
                    Button(action: onReadBook) {
                        Label(bookmarkPage > 0 ? "Resume Book" : "Begin Reading",
                              systemImage: bookmarkPage > 0 ? "bookmark.fill" : "book.fill")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .foregroundStyle(.white)
                    }
                    .glassEffect(.regular.tint(.blue).interactive(), in: .rect(cornerRadius: 24))

                    if bookmarkPage > 0 {
                        Button(action: onRestartBook) {
                            Label("Restart Book", systemImage: "arrow.counterclockwise")
                                .font(.body.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .foregroundStyle(.white)
                        }
                        .glassEffect(.regular.tint(.orange).interactive(), in: .rect(cornerRadius: 24))
                    }

                    Button(action: onSettings) {
                        Label("Settings", systemImage: "gear")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .foregroundStyle(.black)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))

                    Button(action: onAboutAuthor) {
                        Label("About the Author", systemImage: "person.fill")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .frame(height: 46)
                            .foregroundStyle(.black)
                    }
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
                }
                .frame(width: 300)

                Spacer()
                    .frame(height: 20)
            }
        }
    }
}
