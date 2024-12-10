//
//  Posts.swift
//  StreamCity
//
//  Created by Noah Russell on 12/9/24.
//

import Foundation

// Post model
class Post: Identifiable, Equatable, Codable {
    let id: UUID
    let author: String
    let content: String
    let timestamp: Date
    var likes: Int
    var dislikes: Int // Added dislikes

    // Custom initializer with default timestamp, likes, and dislikes set to 0
    init(author: String, content: String, timestamp: Date = Date(), likes: Int = 0, dislikes: Int = 0) {
        self.id = UUID()
        self.author = author
        self.content = content
        self.timestamp = timestamp
        self.likes = likes
        self.dislikes = dislikes
    }

    // Human-readable timestamp (e.g., "5 minutes ago")
    var relativeTimestamp: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    // Full timestamp (e.g., "Dec 10, 2024 at 3:45 PM")
    var fullTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    // Truncated content (to avoid displaying very long posts in a list)
    var truncatedContent: String {
        let maxLength = 100
        if content.count > maxLength {
            let index = content.index(content.startIndex, offsetBy: maxLength)
            return String(content[..<index]) + "..."
        }
        return content
    }

    // Equatable conformance to compare posts by their ID
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

// Mock posts with initial likes and dislikes
let mockPosts = [
    Post(author: "GamerFan45", content: "Anyone watching the tournament today?", timestamp: Date().addingTimeInterval(-1000), likes: 5, dislikes: 2),
    Post(author: "StreamLover", content: "Loving the chill vibes on ArtLover's stream!", timestamp: Date().addingTimeInterval(-3600), likes: 15, dislikes: 0),
    Post(author: "MusicJunkie", content: "Any suggestions for new gaming playlists?", timestamp: Date().addingTimeInterval(-7200), likes: 8, dislikes: 1),
    Post(author: "TechGuru", content: "Just built a new gaming rig. Anyone want to see specs?", timestamp: Date().addingTimeInterval(-5000), likes: 20, dislikes: 3),
    Post(author: "GameMaster3000", content: "How do you guys feel about the new update for Apex?", timestamp: Date().addingTimeInterval(-10000), likes: 10, dislikes: 5)
]
