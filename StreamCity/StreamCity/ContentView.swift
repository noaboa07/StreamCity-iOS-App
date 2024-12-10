//
//  ContentView.swift
//  StreamCity
//
//  Created by Noah Russell on 11/30/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Binding var isLoggedIn: Bool // Allows ContentView to update MainView's login state
    @State private var showLogoutAlert = false // State for alert
    @State private var errorMessage: String? = nil // State for error messages

    var body: some View {
        NavigationStack {
            VStack {
                if isLoggedIn {
                    // Show the MainTabView if the user is logged in
                    MainTabView(isLoggedIn: $isLoggedIn)
                        .transition(.opacity) // Smooth transition for appearance
                        .accessibilityLabel("Main tab view")
                } else {
                    // Display a welcome screen or login placeholder
                    Text("Welcome to StreamCity!")
                        .font(.largeTitle)
                        .padding()
                        .accessibilityLabel("Welcome text")

                    Button(action: {
                        showLogoutAlert = true // Show the alert on button tap
                    }) {
                        Text("Logout")
                            .font(.title2)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .accessibilityLabel("Logout button")
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Logout Confirmation"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Logout")) {
                                do {
                                    try Auth.auth().signOut()
                                    isLoggedIn = false // Update login state
                                } catch {
                                    errorMessage = "Error signing out: \(error.localizedDescription)"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        errorMessage = nil // Reset error message after 3 seconds
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    if let message = errorMessage {
                        Text(message)
                            .foregroundColor(.red)
                            .padding()
                            .transition(.opacity) // Smooth transition for error message
                            .accessibilityLabel("Error message")
                    }
                }
            }
            .padding()
            .animation(.easeInOut, value: isLoggedIn) // Apply animation for UI transition based on login state
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(false)) // Preview with a constant binding
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
