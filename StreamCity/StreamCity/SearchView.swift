//
//  SearchView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = "" // User's search query
    @State private var filteredStreams: [Stream] = mockStreams // Streams filtered by search query
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchQuery)
                    .padding(.horizontal)
                
                // Filtered List of Streams
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredStreams) { stream in
                            NavigationLink(destination: StreamDetailView(stream: stream)) {
                                StreamCardView(stream: stream)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
                .navigationTitle("Search Streams")
                .onChange(of: searchQuery) { _, newQuery in
                    // Filter streams based on search query
                    filterStreams(query: newQuery)
                }
            }
        }
    }
    
    private func filterStreams(query: String) {
        if query.isEmpty {
            filteredStreams = mockStreams
        } else {
            filteredStreams = mockStreams.filter {
                $0.streamerName.lowercased().contains(query.lowercased()) ||
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }
}

struct StreamCardView: View {
    let stream: Stream
    
    var body: some View {
        HStack(spacing: 12) {
            // Stream Thumbnail
            AsyncImage(url: URL(string: stream.thumbnailURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 70)
                        .cornerRadius(8)
                        .clipped()
                        .accessibilityLabel("Thumbnail of the stream titled \(stream.title)")
                case .failure:
                    Color.red
                        .frame(width: 100, height: 70)
                        .cornerRadius(8)
                        .accessibilityLabel("Failed to load thumbnail for \(stream.title)")
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 70)
                        .accessibilityLabel("Loading thumbnail for \(stream.title)")
                @unknown default:
                    Color.gray
                        .frame(width: 100, height: 70)
                        .cornerRadius(8)
                }
            }
            
            // Stream Information
            VStack(alignment: .leading, spacing: 4) {
                Text(stream.streamerName)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibilityLabel("Streamer: \(stream.streamerName)")
                
                Text(stream.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Stream title: \(stream.title)")
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .previewLayout(.sizeThatFits)
    }
}
