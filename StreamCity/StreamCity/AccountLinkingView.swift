//
//  AccountLinkingView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct AccountLinkingView: View {
    @Binding var isLoggedIn: Bool
    @State private var isLoading = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            Text("Link Your Accounts")
                .font(.title)
                .padding()

            if isLoading {
                ProgressView("Linking Account...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                isLoading = true
                linkToTwitch()
            }) {
                Text("Link Twitch Account")
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accessibilityLabel("Link Twitch Account")
            }

            Button(action: {
                isLoading = true
                linkToYouTube()
            }) {
                Text("Link YouTube Account")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accessibilityLabel("Link YouTube Account")
            }

            Button(action: {
                isLoading = true
                linkToFacebookGaming()
            }) {
                Text("Link Facebook Gaming Account")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accessibilityLabel("Link Facebook Gaming Account")
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Account Linking")
    }

    private func linkToTwitch() {
        // Add your OAuth 2.0 authentication flow for Twitch here
        // On success, update `isLoading` and set a success message if needed
        // On failure, set `errorMessage` accordingly
        simulateOAuthProcess(platform: "Twitch")
    }

    private func linkToYouTube() {
        // Add your OAuth 2.0 authentication flow for YouTube Live here
        simulateOAuthProcess(platform: "YouTube")
    }

    private func linkToFacebookGaming() {
        // Add your OAuth 2.0 authentication flow for Facebook Gaming here
        simulateOAuthProcess(platform: "Facebook Gaming")
    }

    private func simulateOAuthProcess(platform: String) {
        // This function simulates an OAuth process for demonstration purposes.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            errorMessage = "\(platform) account linked successfully!"
            // You may replace the above line with actual success or failure handling logic
        }
    }
}

struct AccountLinkingView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLinkingView(isLoggedIn: .constant(true))
    }
}
