//
//  ProfileView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var username: String = "Loading..."
    @State private var profileImage: String = "https://via.placeholder.com/150"
    @State private var age: Int = 18  // Default age
    @State private var followedStreamers: [String] = [] // Updated from mock streamers
    @State private var isLoading: Bool = true
    @State private var hasError: Bool = false
    @Binding var isLoggedIn: Bool
    @State private var showLogoutConfirmation = false

    @State private var showingSettings = false  // To manage the settings sheet

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else {
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
                                .frame(width: 150, height: 150)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Text(username)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)

                        Text("Age: \(age)")
                            .font(.body)
                            .padding(.top)
                    }
                    .padding()

                    VStack(alignment: .leading) {
                        Text("Followed Streamers")
                            .font(.headline)
                            .padding(.top)
                        
                        ScrollView {
                            VStack(alignment: .leading) {
                                ForEach(followedStreamers, id: \.self) { streamer in
                                    Button(action: {
                                        openStreamerProfile(streamer)
                                    }) {
                                        Text(streamer)
                                            .font(.body)
                                            .foregroundColor(.blue)
                                            .padding(.vertical, 2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: ProfileEditView(username: $username, profileImage: $profileImage, age: $age)) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
                    }
                    .padding(.top)

                    Spacer()
                }
            }
            .navigationTitle("Profile")
            .onAppear(perform: loadProfileData)
            .toolbar {
                // Gear icon to open settings
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")  // Gear icon
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $showingSettings) {
                        SettingsView()  // Open the SettingsView when tapped
                    }
                }
                // Logout button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showLogoutConfirmation) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Logout")) {
                                logout()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
        }
        .alert(isPresented: $hasError) {
            Alert(title: Text("Error"), message: Text("There was an issue loading your profile. Please try again later."), dismissButton: .default(Text("OK")))
        }
    }

    private func loadProfileData() {
        guard let user = Auth.auth().currentUser else {
            isLoading = false
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data() ?? [:]
                username = data["username"] as? String ?? "Unknown User"
                profileImage = data["profileImage"] as? String ?? "https://via.placeholder.com/150"
                age = data["age"] as? Int ?? 18  // Default to 18 if no age is stored
                
                // Load followed streamers
                followedStreamers = data["followedStreamers"] as? [String] ?? []
                
                isLoading = false
            } else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                hasError = true
                isLoading = false
            }
        }
    }

    private func openStreamerProfile(_ streamerName: String) {
        // Assuming Twitch as the platform. Change URL as needed for other platforms
        if let url = URL(string: "https://www.twitch.tv/\(streamerName)") {
            UIApplication.shared.open(url)
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
