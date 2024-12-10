//
//  SearchView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery: String = "" // User's search query
    @State private var streams: [Stream] = [] // All fetched streams
    @State private var filteredStreams: [Stream] = [] // Filtered streams
    @State private var isLoading: Bool = false // Loading state
    @State private var debounceTimer: Timer? // For debouncing search input

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar with clear button
                SearchBar(text: $searchQuery)
                    .padding(.horizontal)
                
                // Loading indicator
                if isLoading {
                    ProgressView("Loading streams...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // Show total result count
                    if !searchQuery.isEmpty {
                        Text("\(filteredStreams.count) results found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 5)
                            .padding(.horizontal)
                    }
                    
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
                }
            }
            .onAppear {
                loadStreams(query: nil) // Load all streams initially
            }
            .onChange(of: searchQuery) { newQuery in
                // Debounce the search function to avoid too many API calls
                debounceSearch(query: newQuery)
            }
            .navigationTitle("Search Streams")
        }
    }
    
    // Function to fetch streams from the network
    private func loadStreams(query: String?) {
        isLoading = true
        TwitchNetworkManager.shared.getAccessToken { token in
            if let token = token {
                TwitchNetworkManager.shared.fetchLiveStreams(accessToken: token, query: query) { fetchedStreams in
                    DispatchQueue.main.async {
                        if let fetchedStreams = fetchedStreams {
                            self.streams = fetchedStreams
                            self.filteredStreams = fetchedStreams // Show all initially
                        }
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Failed to retrieve access token")
            }
        }
    }
    
    // Function to filter streams based on search query
    private func filterStreams(query: String) {
        if query.isEmpty {
            filteredStreams = streams
        } else {
            filteredStreams = streams.filter {
                $0.streamerName.lowercased().contains(query.lowercased()) ||
                $0.title.lowercased().contains(query.lowercased())
            }
        }
    }

    // Debounced search to avoid repeated API calls
    private func debounceSearch(query: String) {
        debounceTimer?.invalidate() // Invalidate any existing timer
        
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            filterStreams(query: query)
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
