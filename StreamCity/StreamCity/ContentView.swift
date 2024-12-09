//
//  ContentView.swift
//  StreamCity
//
//  Created by Noah Russell on 11/30/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Binding var isLoggedIn: Bool // This allows ContentView to update the MainView's login state
    @State private var showLogoutAlert = false // State to control the alert
    @State private var errorMessage: String? = nil // State for error messages

    var body: some View {
        NavigationView {
            VStack {
                if isLoggedIn {
                    // Show the MainTabView if the user is logged in
                    MainTabView(isLoggedIn: $isLoggedIn)
                        .transition(.opacity) // Smooth transition for appearance
                } else {
                    // Display a login placeholder or welcome screen
                    Text("Welcome to StreamCity!")
                        .font(.largeTitle)
                        .padding()

                    Button(action: {
                        showLogoutAlert = true // Show the alert when the button is tapped
                    }) {
                        Text("Logout")
                            .font(.title2)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showLogoutAlert) {
                        Alert(
                            title: Text("Logout Confirmation"),
                            message: Text("Are you sure you want to log out?"),
                            primaryButton: .destructive(Text("Logout")) {
                                do {
                                    try Auth.auth().signOut()
                                    isLoggedIn = false // Update the login state
                                } catch {
                                    errorMessage = "Error signing out: \(error.localizedDescription)"
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        errorMessage = nil // Reset the error message after 3 seconds
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
                    }
                }
            }
            .padding()
            .animation(.easeInOut, value: isLoggedIn) // Animation for UI transition based on login state
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(false)) // Pass a constant binding for preview
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
