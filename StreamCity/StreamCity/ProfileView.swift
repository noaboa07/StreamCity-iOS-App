//
//  ProfileView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    // Mock user profile data
    @State private var username: String = "ProGamer123"
    @State private var profileImage: String = "https://via.placeholder.com/150" // Placeholder image
    @State private var followedStreamers: [String] = ["ArtLover", "MusicFanatic"]
    @Binding var isLoggedIn: Bool // Bind this from the parent view to manage login state

    var body: some View {
        NavigationView {
            VStack {
                // Profile Image and Username
                VStack {
                    AsyncImage(url: URL(string: profileImage)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text(username)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                }
                .padding()

                // Followed Streamers List
                VStack(alignment: .leading) {
                    Text("Followed Streamers")
                        .font(.headline)
                        .padding(.top)
                    
                    List(followedStreamers, id: \.self) { streamer in
                        Text(streamer)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)

                // Edit Profile Button
                Button(action: {
                    // Action to edit profile (future feature)
                    print("Edit Profile")
                }) {
                    Text("Edit Profile")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        logout()
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false // Update the login state
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
    }
}
