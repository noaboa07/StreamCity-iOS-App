//
//  Streams.swift
//  StreamCity
//
//  Created by  Noah  Russell on 12/9/24.
//

import Foundation
import SwiftUI

// Stream Model
struct Stream: Identifiable {
    let id = UUID()
    let streamerName: String
    let title: String
    let thumbnailURL: String
    let viewerCount: Int
    let streamCategory: String
    let isLive: Bool
    let streamerAvatarURL: String?
    
    // Computed property for formatted viewer count
    var formattedViewerCount: String {
        if viewerCount >= 1_000 {
            return String(format: "%.1fK", Double(viewerCount) / 1_000)
        } else {
            return "\(viewerCount)"
        }
    }
}

// Mock Stream Data
let mockStreams = [
    Stream(
        streamerName: "ProGamer123",
        title: "Climbing the Ranked Ladder",
        thumbnailURL: "https://via.placeholder.com/300x200",
        viewerCount: 1243,
        streamCategory: "Gaming",
        isLive: true,
        streamerAvatarURL: "https://via.placeholder.com/100"
    ),
    Stream(
        streamerName: "ArtLover",
        title: "Digital Painting Live",
        thumbnailURL: "https://via.placeholder.com/300x200",
        viewerCount: 587,
        streamCategory: "Art",
        isLive: true,
        streamerAvatarURL: "https://via.placeholder.com/100"
    ),
    Stream(
        streamerName: "MusicFanatic",
        title: "Guitar Covers and Requests",
        thumbnailURL: "https://via.placeholder.com/300x200",
        viewerCount: 789,
        streamCategory: "Music",
        isLive: true,
        streamerAvatarURL: "https://via.placeholder.com/100"
    ),
    Stream(
        streamerName: "TechGuru",
        title: "Building a Custom PC Live",
        thumbnailURL: "https://via.placeholder.com/300x200",
        viewerCount: 342,
        streamCategory: "Tech",
        isLive: true,
        streamerAvatarURL: nil
    )
]
