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

    init() { // <-- Add an init
        FirebaseApp.configure() // <-- Configure Firebase app
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
