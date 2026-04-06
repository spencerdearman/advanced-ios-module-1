//
//  StoryPage.swift
//  Storybook

import SwiftUI

enum TextPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomCenter
    case bottomTrailing
    case centerLeading
    case centerTrailing
    case topCenter

    var alignment: Alignment {
        switch self {
        case .topLeading: return .topLeading
        case .topTrailing: return .topTrailing
        case .bottomLeading: return .bottomLeading
        case .bottomCenter: return .bottom
        case .bottomTrailing: return .bottomTrailing
        case .centerLeading: return .leading
        case .centerTrailing: return .trailing
        case .topCenter: return .top
        }
    }

    var textAlignment: TextAlignment {
        switch self {
        case .topLeading, .bottomLeading, .centerLeading: return .leading
        case .topTrailing, .bottomTrailing, .centerTrailing: return .trailing
        case .topCenter, .bottomCenter: return .center
        }
    }

    var horizontalPadding: Edge.Set {
        switch self {
        case .topLeading, .bottomLeading, .centerLeading: return .leading
        case .topTrailing, .bottomTrailing, .centerTrailing: return .trailing
        case .topCenter, .bottomCenter: return .horizontal
        }
    }
}

struct StoryPage {
    let text: String
    let backgroundImage: String
    let textPosition: TextPosition
    
    static let allPages: [StoryPage] = [
        StoryPage(
            text: "Tico soared through the warm wind, listening to the air buzz past. The jungle was safe, bright, and familiar, but the horizon called to him. He wanted to know what colors existed beyond the canopy.",
            backgroundImage: "page1",
            textPosition: .bottomLeading
        ),
        StoryPage(
            text: "Tico arrived in a canyon of glass and steel. Yellow cars rushed below like a noisy, unyielding river. Resting on a high stone ledge, he looked out at the sprawling city. He shrunk from the noise at first, but soon realized that courage meant adapting to unfamiliar skies. He spread his wings and learned to navigate the storm.",
            backgroundImage: "page2",
            textPosition: .topTrailing
        ),
        StoryPage(
            text: "Flying north, the green world faded into an endless expanse of white snow. Tico landed beside a frozen lake, shivering as his feathers offered little protection against the bitter cold. Waiting out the chill, Tico understood that sometimes finding warmth requires patience.",
            backgroundImage: "page3",
            textPosition: .centerLeading
        ),
        StoryPage(
            text: "Tico crossed an ocean to a city glowing with golden streetlights. He flew away from the bright monuments and found a hedge rustling with autumn leaves. The world was very loud, but down here it was peaceful. Tico rested in the stillness, learning that beauty does not always need to be bright to be seen.",
            backgroundImage: "page4",
            textPosition: .bottomTrailing
        ),
        StoryPage(
            text: "The sunrise brought him to forests filled with cedar trees and stone paths. Morning mist rolled through the branches as Tico landed on an old stone lantern. Tico folded his wings, breathing in the quiet rhythm of the earth, realizing the longest journeys require moments of total stillness.",
            backgroundImage: "page5",
            textPosition: .bottomCenter
        ),
        StoryPage(
            text: "Tico journeyed south to the vast, sun-baked plains of Africa. The hot wind swept across the golden grass, carrying red dust into the air. He looked up at the endless horizon, thinking of the ice, glass, and shadows he had seen. The world was incredibly large, but Tico felt a deep comfort that the exact same sky connected it all.",
            backgroundImage: "page6",
            textPosition: .centerTrailing
        ),
        StoryPage(
            text: "His final stop was a brilliant blue ocean. Tico watched the waves crash against the colorful coral reef, each wave moving to its own slow, deliberate rhythm. As the sun set over the water, Tico realized his wings were heavy. He turned back toward Rio. He was returning to the exact same tree, but he was bringing the songs of the entire world home with him.",
            backgroundImage: "page7",
            textPosition: .bottomLeading
        ),
    ]
}
