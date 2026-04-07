//
//  AboutAuthorView.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import SwiftUI

struct AboutAuthorView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.blue)
                    .padding(.top, 30)
                
                Text("About the Author")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Spencer Dearman")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("""
                Spencer Dearman is a passionate iOS developer and storyteller. \
                With a love for creating magical experiences through technology, \
                Spencer combines the art of narrative with the craft of software \
                engineering to bring stories to life on screen.
                
                When not coding, Spencer enjoys exploring new technologies, \
                reading classic literature, and finding inspiration in the world \
                around us. "The Little Star" is Spencer's debut interactive \
                storybook, inspired by the belief that every child deserves to \
                feel special and shine bright.
                """)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}
