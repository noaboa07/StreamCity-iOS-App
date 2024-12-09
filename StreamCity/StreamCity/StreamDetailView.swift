//
//  StreamDetailView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct StreamDetailView: View {
    let stream: Stream
    
    var body: some View {
        VStack {
            // Stream thumbnail
            AsyncImage(url: URL(string: stream.thumbnailURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .clipped()
                } else if phase.error != nil {
                    Color.red // Error placeholder
                } else {
                    Color.gray // Loading placeholder
                }
            }
            
            // Streamer name and title
            VStack(alignment: .leading, spacing: 10) {
                Text(stream.streamerName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(stream.title)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Stream Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
