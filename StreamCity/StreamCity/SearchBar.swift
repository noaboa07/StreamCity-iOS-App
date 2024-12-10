//
//  SearchBar.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            // Magnifying glass icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(isEditing ? .blue : .gray)
            
            // TextField for search input
            TextField("Search", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .padding(7)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .accessibilityLabel("Search for streams")
            .accessibilityHint("Type a keyword to search stream titles, categories, or streamers")
            
            // Clear button when text is entered
            if isEditing && !text.isEmpty {
                Button(action: {
                    text = ""
                    isEditing = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
                .accessibilityLabel("Clear search field")
            }
        }
        .background(Color(.systemGray6))  // Light background for the search bar
        .cornerRadius(8)
        .padding(.horizontal)
        .animation(.easeInOut, value: isEditing)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
