//
//  Posts.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import Foundation

// Post model
struct Post: Identifiable {
    let id = UUID()
    let author: String
    let content: String
    let timestamp: Date
}

// Mock posts
let mockPosts = [
    Post(author: "GamerFan45", content: "Anyone watching the tournament today?", timestamp: Date()),
    Post(author: "StreamLover", content: "Loving the chill vibes on ArtLover's stream!", timestamp: Date().addingTimeInterval(-3600)),
    Post(author: "MusicJunkie", content: "Any suggestions for new gaming playlists?", timestamp: Date().addingTimeInterval(-7200))
]
