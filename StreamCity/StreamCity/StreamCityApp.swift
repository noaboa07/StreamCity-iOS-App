//
//  StreamCityApp.swift
//  StreamCity
//
//  Created by Noah Russell on 11/30/24.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct FireChatApp: App {
    
    // Global dark mode setting using @AppStorage
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false  // Store dark mode preference
    
    init() {
        FirebaseApp.configure()  // Configure Firebase app
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()  // Replace with the root view of your app
                .preferredColorScheme(isDarkMode ? .dark : .light)  // Apply dark mode based on the stored preference
        }
    }
}
