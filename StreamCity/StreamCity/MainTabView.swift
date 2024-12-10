//
//  MainTabView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool // Bind this to control login state
    @State private var username: String = "Loading..." // State to store the username

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .accessibilityLabel("Home Tab")
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .accessibilityLabel("Search Tab")
            
            // Pass the username to CommunityView
            CommunityView(username: $username)
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .accessibilityLabel("Community Tab")
            
            // Pass the binding for isLoggedIn to ProfileView
            ProfileView(isLoggedIn: $isLoggedIn, username: $username) // Pass username here
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .accessibilityLabel("Profile Tab")
        }
        .accentColor(.blue) // Custom color for the tab bar items
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(isLoggedIn: .constant(true)) // Preview with a dummy binding
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
