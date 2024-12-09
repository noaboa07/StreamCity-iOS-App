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
                // Post Input Field
                HStack {
                    TextField("Share something...", text: $newPostText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button(action: addPost) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .padding()
                    }
                    .disabled(newPostText.isEmpty)
                }

                // List of Posts
                List(posts) { post in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(post.author)
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text(post.content)
                            .font(.body)
                        Text(post.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
                .navigationTitle("Community")
            }
        }
    }
    
    // Add a new post
    private func addPost() {
        let newPost = Post(author: "You", content: newPostText, timestamp: Date())
        posts.insert(newPost, at: 0)
        newPostText = ""
    }
}
