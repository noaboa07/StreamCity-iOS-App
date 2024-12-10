//
//  CommunityView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct CommunityView: View {
    @State private var posts: [Post] = mockPosts // List of posts
    @State private var newPostText: String = "" // Text for new posts
    
    var body: some View {
        NavigationView {
            VStack {
                // Post Input Field with improved placeholder and character limit
                HStack {
                    TextField("What's on your mind?", text: $newPostText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(height: 44) // Adjust height for better UI consistency
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Button(action: addPost) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .padding()
                            .foregroundColor(newPostText.isEmpty ? .gray : .blue)
                    }
                    .disabled(newPostText.isEmpty)
                }
                .padding(.horizontal)
                
                Divider()
                
                // List of Posts
                List(posts) { post in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.author)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                        Text(post.content)
                            .font(.body)
                        
                        // Enhanced timestamp display
                        Text(formatTimestamp(post.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                .navigationTitle("Community")
            }
            // Updated line for iOS 17.0+
            .onChange(of: newPostText) {
                // Handle changes to newPostText if needed
            }
        }
    }
    
    // Add a new post
    private func addPost() {
        guard !newPostText.isEmpty else { return }
        let newPost = Post(author: "You", content: newPostText, timestamp: Date())
        posts.insert(newPost, at: 0)
        newPostText = ""
    }
    
    // Helper function to format the timestamp into a readable string
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
