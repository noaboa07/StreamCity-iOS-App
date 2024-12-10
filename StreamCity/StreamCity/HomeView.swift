//
//  HomeView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct HomeView: View {
    @State private var streams: [Stream] = [] // Data source for streams
    @State private var isLoading: Bool = false // Loading state for data fetching

    var body: some View {
        NavigationView {
            VStack {
                // Title at the top
                Text("Recommended for you:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                // If loading, show progress indicator
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // Display top 10 streams
                    List(streams.prefix(10)) { stream in
                        NavigationLink(destination: StreamDetailView(stream: stream)) {
                            HStack {
                                // Streamer avatar with AsyncImage
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
                                        Text(stream.formattedViewerCount + " viewers")
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
                    .navigationTitle("Trending Now")
                    .disabled(isLoading)  // Disable list interaction while loading
                    
                    // Button to go to SearchView (full list of streams)
                    NavigationLink(destination: SearchView()) {
                        Text("Browse Streams")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                            .padding(.top, 10)
                    }
                }
            }
            .onAppear {
                loadStreams()
            }
        }
    }

    // Function to load streams from the Twitch API
    private func loadStreams() {
        isLoading = true
        TwitchNetworkManager.shared.getAccessToken { token in
            if let token = token {
                TwitchNetworkManager.shared.fetchLiveStreams(accessToken: token) { fetchedStreams in
                    DispatchQueue.main.async {
                        if let fetchedStreams = fetchedStreams {
                            self.streams = fetchedStreams
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

