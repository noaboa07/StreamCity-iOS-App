//
//  HomeView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = "" // Search query state
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search streams...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Filtered Stream List
                List(filteredStreams) { stream in
                    NavigationLink(destination: StreamDetailView(stream: stream)) {
                        HStack {
                            // Stream thumbnail
                            AsyncImage(url: URL(string: stream.thumbnailURL)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 60)
                                        .cornerRadius(8)
                                        .clipped()
                                } else if phase.error != nil {
                                    Color.red // Error placeholder
                                } else {
                                    Color.gray // Loading placeholder
                                }
                            }
                            
                            // Streamer details
                            VStack(alignment: .leading) {
                                Text(stream.streamerName)
                                    .font(.headline)
                                Text(stream.title)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .navigationTitle("Live Streams")
            }
        }
    }
    
    // Computed property to filter streams
    private var filteredStreams: [Stream] {
        if searchText.isEmpty {
            return mockStreams
        } else {
            return mockStreams.filter { stream in
                stream.streamerName.lowercased().contains(searchText.lowercased()) ||
                stream.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
