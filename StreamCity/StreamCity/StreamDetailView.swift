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
        ScrollView {
            VStack(spacing: 16) {
                // Stream thumbnail with loading and error states
                AsyncImage(url: URL(string: stream.thumbnailURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()
                            .accessibilityLabel("Thumbnail of the stream titled \(stream.title)")
                    case .failure:
                        VStack {
                            Text("Image not available")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.red)
                                .cornerRadius(8)
                            Color.red
                                .frame(height: 200)
                                .cornerRadius(12)
                        }
                        .accessibilityLabel("Failed to load thumbnail for \(stream.title)")
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .accessibilityLabel("Loading thumbnail for \(stream.title)")
                    @unknown default:
                        Color.gray
                            .frame(height: 200)
                            .cornerRadius(12)
                    }
                }
                
                // Streamer details
                VStack(alignment: .leading, spacing: 10) {
                    Text(stream.streamerName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .accessibilityLabel("Streamer: \(stream.streamerName)")
                    
                    Text(stream.title)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Stream Title: \(stream.title)")
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
            .padding()
        }
        .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Stream Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StreamDetailView(stream: mockStreams[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
