//
//  StoryPage.swift
//  Storybook

import SwiftUI

enum TextPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    case centerLeading
    case centerTrailing
    case topCenter
    
    var alignment: Alignment {
        switch self {
        case .topLeading: return .topLeading
        case .topTrailing: return .topTrailing
        case .bottomLeading: return .bottomLeading
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
        case .topCenter: return .center
        }
    }
    
    var horizontalPadding: Edge.Set {
        switch self {
        case .topLeading, .bottomLeading, .centerLeading: return .leading
        case .topTrailing, .bottomTrailing, .centerTrailing: return .trailing
        case .topCenter: return .horizontal
        }
    }
}

struct StoryPage {
    let text: String
    let backgroundImage: String
    let textPosition: TextPosition
    
    static let allPages: [StoryPage] = [
        StoryPage(
            text: "Pico stood on his high branch in Rio de Janeiro, listening to the wind. The jungle was safe, bright, and familiar, but the horizon called to him. He wanted to know how the rest of the world sounded and what colors existed beyond the canopy. With a deep breath, he spread his wings and launched into the boundless sky, leaving his leafy home behind.",
            backgroundImage: "page1",
            textPosition: .bottomLeading
        ),
        StoryPage(
            text: "Pico arrived in a canyon of glass and steel. Yellow cars rushed below like a noisy, unyielding river. Resting on a high stone ledge, he looked out at the sprawling city. There were no trees here, only towering concrete and howling wind. He shrunk from the noise at first, but soon realized that courage meant adapting to unfamiliar skies. He spread his wings and learned to navigate the storm.",
            backgroundImage: "page2",
            textPosition: .topTrailing
        ),
        StoryPage(
            text: "Flying north, the green world faded into an endless expanse of white snow. Pico landed beside a frozen lake, shivering as his feathers offered little protection against the bitter cold. He found shelter under a thick pine branch, shielding himself from the wind. Waiting out the chill, Pico understood that sometimes finding warmth requires patience and effort.",
            backgroundImage: "page3",
            textPosition: .centerLeading
        ),
        StoryPage(
            text: "Pico crossed an ocean to a city glowing with golden streetlights. He flew away from the bright, towering monuments and found a quiet hedge rustling with autumn leaves. The world above was very loud, but down here it was peaceful. Pico rested in the stillness, learning that beauty does not always need to be bright to be seen.",
            backgroundImage: "page4",
            textPosition: .bottomTrailing
        ),
        StoryPage(
            text: "The sunrise brought him to ancient forests filled with cedar trees and stone paths. Morning mist rolled silently through the branches as Pico landed on an old stone lantern. He had flown so far, but the serene atmosphere reminded him to pause. Pico folded his wings, breathing in the quiet rhythm of the earth, realizing the longest journeys require moments of total stillness.",
            backgroundImage: "page5",
            textPosition: .topCenter
        ),
        StoryPage(
            text: "Pico journeyed south to the vast, sun-baked plains of Africa. The hot wind swept across the golden grass, carrying red dust into the air. He looked up at the endless horizon, thinking of the ice, glass, and shadows he had seen. The world was incredibly large, but Pico felt a comforting truth in the heavy air: the exact same sky connected it all.",
            backgroundImage: "page6",
            textPosition: .centerTrailing
        ),
        StoryPage(
            text: "His final stop was a brilliant blue ocean. Pico watched the waves crash against the colorful coral reef, each wave moving to its own slow, deliberate rhythm. As the sun set over the water, Pico realized his wings were heavy. He turned back toward Rio. He was returning to the exact same tree, but he was bringing the songs of the entire world home with him.",
            backgroundImage: "page7",
            textPosition: .bottomLeading
        ),
    ]
}
