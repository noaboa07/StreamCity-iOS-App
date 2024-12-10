//
//  HomeView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText: String = "" // Search query state
    @State private var streams: [Stream] = [] // Data source for streams
    @State private var isLoading: Bool = false // Loading state for data fetching

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                TextField("Search streams...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) {
                        // Filter streams on text change
                        filterStreams()
                    }

                // Filtered Stream List
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List(filteredStreams) { stream in
                        NavigationLink(destination: StreamDetailView(stream: stream)) {
                            HStack {
                                // Streamer avatar
                                AsyncImage(url: URL(string: stream.streamerAvatarURL ?? "")) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } else if phase.error != nil {
                                        Image(systemName: "person.crop.circle.badge.xmark")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.red)
                                    } else {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    }
                                }

                                // Stream details
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(stream.streamerName)
                                        .font(.headline)
                                    Text(stream.title)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    HStack {
                                        Text("\(stream.viewerCount) viewers")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(stream.streamCategory)
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }

                                Spacer()

                                // Live status indicator
                                if stream.isLive {
                                    Text("LIVE")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                        .padding(6)
                                        .background(Color.red.opacity(0.1))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Live Streams")
                }
            }
            .onAppear {
                loadStreams()
            }
        }
    }

    // Computed property to filter streams
    private var filteredStreams: [Stream] {
        if searchText.isEmpty {
            return streams
        } else {
            return streams.filter { stream in
                stream.streamerName.lowercased().contains(searchText.lowercased()) ||
                stream.title.lowercased().contains(searchText.lowercased()) ||
                stream.streamCategory.lowercased().contains(searchText.lowercased())
            }
        }
    }

    // Function to load streams from the Twitch API
    private func loadStreams() {
        isLoading = true
        TwitchNetworkManager.shared.getAccessToken { token in
            if let token = token {
                TwitchNetworkManager.shared.fetchLiveStreams(accessToken: token) { fetchedStreams in
                    if let fetchedStreams = fetchedStreams {
                        DispatchQueue.main.async {
                            self.streams = fetchedStreams
                            self.isLoading = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                        print("Failed to fetch streams")
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

    // Function to filter streams based on search text
    private func filterStreams() {
        // You could implement more complex search filtering logic here if needed
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
