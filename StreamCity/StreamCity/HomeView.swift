//
//  HomeView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
    @State private var streams: [Stream] = [] // Data source for streams
    @State private var isLoading: Bool = false // Loading state for data fetching
    @State private var followedStreamers: [String] = [] // List of followed streamers

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
                            
                            // Follow Button (plus or checkmark icon)
                            Button(action: {
                                if followedStreamers.contains(stream.streamerName) {
                                    unfollowStreamer(stream.streamerName)
                                } else {
                                    followStreamer(stream.streamerName)
                                }
                            }) {
                                Image(systemName: followedStreamers.contains(stream.streamerName) ? "checkmark.circle.fill" : "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(followedStreamers.contains(stream.streamerName) ? .gray : .blue)
                            }
                            .padding(.trailing)
                            .disabled(isLoading) // Disable button if loading
                        }
                        .padding(.vertical, 8)
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
                loadFollowedStreamers() // Load followed streamers when the HomeView appears
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

    // Function to load followed streamers from Firestore
    private func loadFollowedStreamers() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                followedStreamers = data["followedStreamers"] as? [String] ?? []
            }
        }
    }

    // Function to follow a streamer and update Firestore
    private func followStreamer(_ streamerName: String) {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        // Only add the streamer if it's not already followed
        if !followedStreamers.contains(streamerName) {
            followedStreamers.append(streamerName)

            // Update Firestore
            userRef.updateData([
                "followedStreamers": followedStreamers
            ]) { error in
                if let error = error {
                    print("Error following streamer: \(error.localizedDescription)")
                } else {
                    print("Streamer followed successfully!")
                }
            }
        }
    }

    // Function to unfollow a streamer and update Firestore
    private func unfollowStreamer(_ streamerName: String) {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        // Remove streamer from the followed list
        followedStreamers.removeAll { $0 == streamerName }

        // Update Firestore
        userRef.updateData([
            "followedStreamers": followedStreamers
        ]) { error in
            if let error = error {
                print("Error unfollowing streamer: \(error.localizedDescription)")
            } else {
                print("Streamer unfollowed successfully!")
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

