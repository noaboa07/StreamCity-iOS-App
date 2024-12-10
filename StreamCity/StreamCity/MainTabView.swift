//
//  MainTabView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct MainTabView: View {
    @Binding var isLoggedIn: Bool // Bind this to control login state

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
            
            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }
                .accessibilityLabel("Community Tab")
            
            ProfileView(isLoggedIn: $isLoggedIn) // Pass the binding here
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
