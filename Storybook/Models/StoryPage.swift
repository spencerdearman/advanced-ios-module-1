//
//  StoryPage.swift
//  Storybook
//

import SwiftUI

struct StoryPage {
    let text: String
    let backgroundColor: Color

    static let allPages: [StoryPage] = [
        StoryPage(
            text: "Once upon a time, in a sky full of twinkling lights, there lived a little star named Lumi. Lumi was the smallest star in the constellation, but had the biggest dreams.",
            backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.3)
        ),
        StoryPage(
            text: "Every night, Lumi watched the children below gazing up at the sky. \"I wish I could shine bright enough for them to see me,\" Lumi whispered to the Moon.",
            backgroundColor: Color(red: 0.15, green: 0.1, blue: 0.35)
        ),
        StoryPage(
            text: "The Moon smiled warmly. \"Little one, it is not about how bright you shine, but about how much heart you put into your glow. Try shining with all your love.\"",
            backgroundColor: Color(red: 0.1, green: 0.15, blue: 0.35)
        ),
        StoryPage(
            text: "So Lumi closed its eyes and thought of all the children, the dreamers, the wishers, and the stargazers. A warm feeling filled Lumi from the inside out.",
            backgroundColor: Color(red: 0.2, green: 0.1, blue: 0.3)
        ),
        StoryPage(
            text: "Suddenly, Lumi began to glow brighter than ever before! The children below pointed up and cheered. \"Look! A new star!\" they cried with delight.",
            backgroundColor: Color(red: 0.15, green: 0.15, blue: 0.4)
        ),
        StoryPage(
            text: "From that night on, Lumi shone with all the love in its heart. And whenever a child made a wish upon a star, it was Lumi who carried that wish across the sky. The End.",
            backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.25)
        ),
    ]
}
