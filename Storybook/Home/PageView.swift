//
//  PageView.swift
//  Storybook
//
//  Created by Spencer Dearman on 3/30/26.
//

import SwiftUI

public struct PageView: View {
    let pageText: String
    let backgroundColor: Color
    
    // Return to Home button required on every page
    var onReturnHome: () -> Void
    
    public var body: some View {
        Text("Page View")
    }
}
