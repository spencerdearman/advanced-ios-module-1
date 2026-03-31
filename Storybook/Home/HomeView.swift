//
//  HomeView.swift
//  Storybook
//
//  Created by Spencer Dearman on 3/30/26.
//

import SwiftUI

struct HomeView: View {
    
    var onButtonTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Spencer Dearman")
                .font(.title2)
                .fontWeight(.semibold)
            
            
            Button {
                onButtonTapped()
            } label: {
                Text("Read Book")
                    .font(.title3)
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        }
    }
}
