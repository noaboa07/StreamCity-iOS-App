//
//  MainView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @State private var isLoggedIn = false // Non-optional Bool to track authentication state
    @State private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    var body: some View {
        NavigationStack {
            VStack {
                if isLoggedIn {
                    // Pass the isLoggedIn state directly to ContentView
                    ContentView(isLoggedIn: $isLoggedIn)
                        .transition(.opacity)
                        .accessibilityLabel("Logged in content view")
                } else {
                    // Pass the binding to a false value for LoginView
                    LoginView(isLoggedIn: $isLoggedIn)
                        .transition(.opacity)
                        .accessibilityLabel("Login view")
                }
            }
            .onAppear {
                authStateListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
                    withAnimation {
                        isLoggedIn = user != nil
                    }
                }
            }
            .onDisappear {
                if let handle = authStateListenerHandle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
            }
            .animation(.default, value: isLoggedIn) // Apply animation only when isLoggedIn changes
        }
    }
}
