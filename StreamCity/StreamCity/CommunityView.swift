//
//  CommunityView.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import SwiftUI

struct CommunityView: View {
    @State private var posts: [Post] = [] // List of posts
    @State private var newPostText: String = "" // Text for new posts
    @Binding var username: String // Binding to the username

    // Track which posts the user has liked/disliked
    @State private var likedPosts: Set<UUID> = []
    @State private var dislikedPosts: Set<UUID> = []

    var body: some View {
        NavigationView {
            VStack {
                // Post Input Field with improved placeholder and character limit
                HStack {
                    TextField("What's on your mind?", text: $newPostText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(height: 44)
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
                        
                        Text(post.truncatedContent)
                            .font(.body)
                            .foregroundColor(.primary)
                        
                        Text(post.relativeTimestamp)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        // Like and Dislike Buttons
                        HStack {
                            Text("\(post.likes) Likes")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Button(action: { likePost(post) }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(likedPosts.contains(post.id) ? .green : .blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                            
                            Text("\(post.dislikes) Dislikes")
                                .font(.caption)
                                .foregroundColor(.red)
                            
                            Button(action: { dislikePost(post) }) {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .foregroundColor(dislikedPosts.contains(post.id) ? .orange : .red)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.top, 4)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                }
                .navigationTitle("Community")
            }
            .onAppear {
                loadPosts() // Load posts from UserDefaults when the view appears
            }
        }
    }
    
    // Add a new post
    private func addPost() {
        guard !newPostText.isEmpty else { return }
        let newPost = Post(author: username, content: newPostText, timestamp: Date(), likes: 0, dislikes: 0)
        posts.insert(newPost, at: 0) // Add new post at the top
        newPostText = "" // Clear input field
        savePosts() // Save posts after adding
    }
    
    // Like a post (increment likes count)
    private func likePost(_ post: Post) {
        guard !likedPosts.contains(post.id) else { return } // Prevent multiple likes
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].likes += 1
            likedPosts.insert(post.id) // Track that the user has liked the post
            savePosts() // Save updated likes
        }
    }
    
    // Dislike a post (increment dislikes count)
    private func dislikePost(_ post: Post) {
        guard !dislikedPosts.contains(post.id) else { return } // Prevent multiple dislikes
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].dislikes += 1
            dislikedPosts.insert(post.id) // Track that the user has disliked the post
            savePosts() // Save updated dislikes
        }
    }
    
    // Save posts to UserDefaults for persistence
    private func savePosts() {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: "savedPosts")
        } else {
            print("Failed to encode posts")
        }
    }
    
    // Load posts from UserDefaults
    private func loadPosts() {
        if let savedPosts = UserDefaults.standard.data(forKey: "savedPosts"),
           let decodedPosts = try? JSONDecoder().decode([Post].self, from: savedPosts) {
            posts = decodedPosts
        } else {
            // If no saved posts exist, use mock data
            posts = mockPosts
        }
    }
}

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(username: .constant("GamerFan45"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
