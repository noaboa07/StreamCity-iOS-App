//
//  StreamDetailView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct StreamDetailView: View {
    let stream: Stream
    
    // Twitch Stream URL
    private var streamURL: String {
        "https://www.twitch.tv/\(stream.streamerName)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Stream thumbnail with loading, success, and failure states
                AsyncImage(url: URL(string: stream.thumbnailURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .cornerRadius(12)
                            .clipped()
                            .onTapGesture {
                                openStream()
                            }
                            .accessibilityLabel("Thumbnail of the stream titled \(stream.title)")
                    case .failure:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .frame(height: 200)
                            .scaledToFit()
                            .cornerRadius(12)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .onTapGesture {
                                openStream()
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

                    HStack {
                        Text("\(stream.formattedViewerCount) viewers")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(stream.streamCategory)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
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
    
    // Function to open stream URL in Safari
    private func openStream() {
        if let url = URL(string: streamURL) {
            UIApplication.shared.open(url)
        }
    }
}

struct StreamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StreamDetailView(stream: mockStreams[0])
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
