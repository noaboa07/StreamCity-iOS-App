//
//  SettingsView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/10/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false  // Persist dark mode preference

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $isDarkMode) {
                        Text("Enable Dark Mode")
                    }
                }
            }
            .navigationTitle("Settings")
            .onChange(of: isDarkMode) { _ in
                // The color scheme is updated automatically when the toggle is changed
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)  // Apply dark mode to this view
    }
}
