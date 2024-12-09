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
                    .padding()

                // Filtered List of Streams
                List(filteredStreams) { stream in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(stream.streamerName)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(stream.title)
                            .font(.body)
                            .foregroundColor(.gray)
                        AsyncImage(url: URL(string: stream.thumbnailURL)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 70)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding(.vertical, 5)
                }
                .navigationTitle("Search")
            }
            // Updated onChange modifier for iOS 17+
            .onChange(of: searchQuery) { _, newQuery in
                // Filter streams based on search query
                filterStreams(query: newQuery)
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
